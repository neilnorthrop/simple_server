require 'socket'
require_relative 'logging'
require_relative 'request'
require_relative 'response'
require_relative 'file_handler'

class SimpleServer
  attr_reader :server, :level, :output, :host, :port, :request

  READ_CHUNK = 1024 * 4

  LOG = Logging.setup
  LOG.debug("Logging is set up.")

  def initialize(host='localhost', port=2345)
    @host    = host
    @port    = port
    @server  = TCPServer.new(host, port)
    @request = Request.new
    LOG.debug("Server is set up.")
  end

  def server_info
    puts "#{'-' * 30}\nWelcome to the Simple Server.\nIt is running on http://#{host}#{(":" + port.to_s) if port}\nPlease use CONTROL-C to exit.\n#{'-' * 30}\n\n"
  end

  def run
    server_info
    begin
      loop do
        Thread.start(server.accept) do |socket|
          LOG.debug("Accepted socket: #{socket.inspect}\r\n")

        begin
          data = socket.readpartial(READ_CHUNK)
        rescue EOFError
          break
        end
          logging_string(data)
          # LOG.debug("Incoming request: #{request.inspect}\r\n")
          # LOG.debug("Built response: #{response.inspect}\r\n")

          response = request.build(data)
          socket.print response.stream
          logging_string(response.header)

          socket.close
        end
      end
    rescue Interrupt
      puts "\nExiting...Thank you for using this super awesome server."
    end
  end

  def logging_string(string)
    string = string.split("\r\n")
    string.each do |line|
      LOG.info(line)
    end
  end

end
