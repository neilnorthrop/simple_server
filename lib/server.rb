require 'socket'
require_relative 'request'

class Server
  attr_reader :server

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

  def run
    begin
      loop do
        socket = server.accept
        request = Request.parse(socket.gets)
        STDERR.puts request
        socket.puts "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: text/plain\r\n" +
                    "Content-Length: 12\r\n" +
                    "Connection: close\r\n"
        socket.print "\r\n"
        socket.close
      end
    rescue Interrupt
      puts "\nExiting...Thank you for using this super awesome server."
    end
  end
end