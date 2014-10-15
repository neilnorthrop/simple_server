require 'socket'

class Server
  attr_reader :port, :host, :server
  def initialize(host='localhost', port=2345)
    @port = 2345
    @host = 'localhost'
    @server = build_server(host, port)
  end

  def run
    loop do
      socket = server.accept
      request = socket.gets
      STDERR.puts request
      response = "Hello World"
      socket.puts "HTTP/1.1 200 OK\r\n" +
                  "Content-Type: text/plain\r\n" +
                  "Content-Length: #{response.bytesize}\r\n" +
                  "Connection: close\r\n"
      socket.print "\r\n"
      socket.print response
      socket.close
    end
  end

  def build_server(host, port)
    TCPServer.new(host, port)
  end
end