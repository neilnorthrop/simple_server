require 'socket'
require_relative 'logging'
require_relative 'request'
require_relative 'response'

class SimpleServer
  attr_reader :server, :level, :output, :host, :port

  READ_CHUNK = 1024 * 4

  RESPONSE_CODE = {
    '100' => 'Continue',
    '200' => 'OK',
    '201' => 'Created',
    '202' => 'Accepted',
    '400' => 'Bad Request',
    '403' => 'Forbidden',
    '404' => 'Not Found',
    '500' => 'Internal Server Error',
    '502' => 'Bad Gateway'
  }

  CONTENT_TYPE_MAPPING = {
    'html' => 'text/html',
    'txt'  => 'text/plain',
    'png'  => 'image/png',
    'jpg'  => 'image/jpg',
    'haml' => 'text/html'
  }

  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

  NOT_FOUND = './public/404.html'

  LOG = Logging.setup
  LOG.debug("Logging is set up.")

  def initialize(host='localhost', port=2345)
    @host = host
    @port = port
    @server = TCPServer.new(host, port)
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

          request = Request.parse(data)
          header, body = get_requested_file(request.resource)
          LOG.debug("Incoming request: #{request.inspect}\r\n")
          response = Response.build(header, body)
          LOG.debug("Built response: #{response.inspect}\r\n")
          socket.print response.header
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

  def get_requested_file(path)
    path = File.join(path, 'index.html') if File.directory?(path)
    if File.exist?(path) && !File.directory?(path)
      body, body_size = build_body(path)
      header = build_header(RESPONSE_CODE.rassoc('OK').join("/"),
                           content_type(path),
                           body_size)
      return header, body
    else
      body, body_size = build_body(NOT_FOUND)
      header = build_header(RESPONSE_CODE.rassoc('Not Found').join("/"),
                           content_type(path),
                           body_size)
      return header, body
    end
  end

  def content_type(path)
    ext = File.extname(path).split('.').last
    CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
  end

  def build_header(code, type, size)
    "HTTP/1.1 #{code}\r\n" +
    "Content-Type: #{type}\r\n" +
    "Content-Length: #{size}\r\n" +
    "Connection: close\r\n\r\n"
  end

  def build_body(path)
    File.open(path, "rb") do |file|
      return file, file.size
    end
  end

end
