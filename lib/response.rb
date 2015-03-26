require 'socket'

class Response
  attr_reader :header, :body

  def initialize(header, body)
    @header = header
    @body = body
  end

  def self.build(header, body)
    Response.new(header, body)
  end

  def stream
    File.read(self.body)
  end

end
