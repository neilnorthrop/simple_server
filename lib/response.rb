require 'socket'

class Response
  attr_reader :header, :body

  def initialize(header, body)
    @header = header
    @body = body
  end

  def self.build_header(file_handler)
    header = header(file_handler)
    body = file_handler.body
    Response.new(header, body)
  end

  def stream
    File.read(self.body)
  end

  def self.header(file_handler)
    "HTTP/1.1 #{file_handler.response_code}\r\n" +
    "Content-Type: #{file_handler.content_type}\r\n" +
    "Content-Length: #{file_handler.file_size}\r\n" +
    "Connection: close\r\n\r\n"
  end

end
