require 'socket'

class Response

	RESPONSE_CODE = {
		'200' => 'OK',
		'404' => 'Not Found'
	}

  CONTENT_TYPE_MAPPING = {
    'html' => 'text/html',
    'txt'  => 'text/plain',
    'png'  => 'image/png',
    'jpg'  => 'image/jpg'
  }

  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

  NOT_FOUND = './public/404.html'

	def self.build_response(path, socket)
    if File.exist?(path) && !File.directory?(path)
      serve_response(path, socket, RESPONSE_CODE.rassoc('OK'))
    else
      serve_response(NOT_FOUND, socket, RESPONSE_CODE.rassoc('Not Found'))
    end
	end

  def self.content_type(path)
    ext = File.extname(path).split('.').last
    CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
  end

  def self.content(code, type, size)
  	"HTTP/1.1 #{code}\r\n" + 
		"Content-Type: #{type}\r\n" +
		"Content-Length: #{size}\r\n" +
		"Connection: close\r\n\r\n"
  end

  def self.serve_response(path, socket, code)
    File.open(path, "rb") do |file|
      socket.print content(code.join,
                           content_type(path),
                           file.size)
      IO.copy_stream(file, socket)
    end
  end
end