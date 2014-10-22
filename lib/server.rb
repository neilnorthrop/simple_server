require 'socket'
require_relative 'request'

class Server
  attr_reader :server

  WEB_ROOT = './public'

  CONTENT_TYPE_MAPPING = {
    'html' => 'text/html',
    'txt'  => 'text/plain',
    'png'  => 'image/png',
    'jpg'  => 'image/jpg'
  }

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
        
        socket.print "\r\n"
        
        IO.copy_stream(file, socket)
      end
    else
      File.open('./public/404.html', "rb") do |file|

        socket.print "HTTP/1.1 404 Not Found\r\n" +
                     "Content-Type: #{content_type(file)}\r\n" +
                     "Content-Length #{file.size}\r\n" +
                     "Connection: close\r\n"
        
        socket.print "\r\n"
        
        IO.copy_stream(file, socket)
      end
    end
  end

  def run
    begin
      loop do
        Thread.start(server.accept) do |socket|
          request = Request.parse(socket.gets)          
          STDERR.puts request          
          path = clean_path(request.resource)         
          path = File.join(path, 'index.html') if File.directory?(path)         
          request(path, socket)         
          socket.close
        end
      end
    rescue Interrupt
      puts "\nExiting...Thank you for using this super awesome server."
    end
  end
end