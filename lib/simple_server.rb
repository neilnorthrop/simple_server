require 'socket'
require_relative 'logging'
require_relative 'request'

class SimpleServer
  attr_reader :server, :level, :output

  WEB_ROOT = './public'

  CONTENT_TYPE_MAPPING = {
    'html' => 'text/html',
    'txt'  => 'text/plain',
    'png'  => 'image/png',
    'jpg'  => 'image/jpg'
  }

  LOG = Logging.setup

  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

  def initialize(host='localhost', port=2345)
    @server = TCPServer.new(host, port)
  end

  def content_type(path)
    ext = File.extname(path).split('.').last
    CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
  end
  
  def clean_path(path)
    clean = []

    parts = path.split("/")
    parts.each do |part|
      next if part.empty? || part == '.'
      part == '..' ? clean.pop : clean << part
    end 
    File.join(WEB_ROOT, *clean)
  end

  def request(path, socket)
    if File.exist?(path) && !File.directory?(path)
      File.open(path, "rb") do |file|
        socket.print "HTTP/1.1 200 OK\r\n" +
                     "Content-Type: #{content_type(file)}\r\n" +
                     "Content-Length: #{file.size}\r\n" +
                     "Connection: close\r\n"

        LOG.info     "HTTP/1.1 200 OK " +
                     "Content-Type: #{content_type(file)} " +
                     "Content-Length: #{file.size} " +
                     "Connection: close"
        
        socket.print "\r\n"
        
        IO.copy_stream(file, socket)
      end
    else
      File.open('./public/404.html', "rb") do |file|

        socket.print "HTTP/1.1 404 Not Found\r\n" +
                     "Content-Type: #{content_type(file)}\r\n" +
                     "Content-Length #{file.size}\r\n" +
                     "Connection: close\r\n"

        LOG.info     "HTTP/1.1 404 Not Found " +
                     "Content-Type: #{content_type(file)} " +
                     "Content-Length #{file.size} " +
                     "Connection: close"
        
        socket.print "\r\n"
        
        IO.copy_stream(file, socket)
      end
    end
  end

  def server_info
    puts "#{'-' * 30}\nWelcome to the Simple Server.\nPlease use CONTROL-C to exit.\n#{'-' * 30}\n\n"
  end

  def run
    server_info
    begin
      loop do
        Thread.start(server.accept) do |socket|
          LOG.debug("Accepted socket: #{socket.inspect}")
          request = Request.parse(socket.gets)
          LOG.debug("Incoming request: #{request.inspect}")
          path = clean_path(request.resource)
          path = File.join(path, 'index.html') if File.directory?(path)
          LOG.debug("Requested path: #{path.inspect}")
          request(path, socket)
          socket.close
        end
      end
    rescue Interrupt
      puts "\nExiting...Thank you for using this super awesome server."
    end
  end
end