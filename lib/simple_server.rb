require 'socket'
require_relative 'logging'
require_relative 'request'
require_relative 'response'

class SimpleServer
  attr_reader :server, :level, :output

  WEB_ROOT = './public'

  LOG = Logging.setup

  def initialize(host='localhost', port=2345)
    @server = TCPServer.new(host, port)
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
          Response.build_response(path, socket)
          socket.close
        end
      end
    rescue Interrupt
      puts "\nExiting...Thank you for using this super awesome server."
    end
  end
end