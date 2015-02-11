require 'socket'
require_relative 'logging'
require_relative 'request'
require_relative 'response'

class SimpleServer
  attr_reader :server, :level, :output, :host, :port

  READ_CHUNK = 1024 * 4
  WEB_ROOT = './public'

  LOG = Logging.setup
  LOG.debug("Logging is set up.")

  def initialize(host='localhost', port=2345)
    @host = host
    @port = port
    @server = TCPServer.new(host, port)
    LOG.debug("Server is set up.")
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
    puts "#{'-' * 30}\nWelcome to the Simple Server.\nIt is running on http://#{host}#{(":" + port.to_s) if port}\nPlease use CONTROL-C to exit.\n#{'-' * 30}\n\n"
  end

  def run
    server_info
    begin
      loop do
        Thread.start(server.accept) do |socket|
          LOG.debug("Accepted socket: #{socket.inspect}")
          
        begin
          data = socket.readpartial(READ_CHUNK)
        rescue EOFError
          break
        end
          # LOG.debug("INCOMING FROM SOCKET: \n#{data}")
          logging_header(data)
          
          request = Request.parse(data)
          LOG.debug("Incoming request: #{request.inspect}")
          
          path = clean_path(request.resource)
          path = File.join(path, 'index.html') if File.directory?(path)
          LOG.debug("Requested path: #{path.inspect}")
          
          response = Response.build(path)
          socket.print response.header
          socket.print response.stream
          logging_header(response.header)
          socket.close
        end
      end
    rescue Interrupt
      puts "\nExiting...Thank you for using this super awesome server."
    end
  end

  def logging_header(header)
    header = header.split("\r\n")
    header.each do |line|
      LOG.info(line)
    end
  end
end