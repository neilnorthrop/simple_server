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

	def self.build_response(path, socket)
    if File.exist?(path) && !File.directory?(path)
      File.open(path, "rb") do |file|
        socket.print content(content_type(path),
        										 file.size, 
        										 RESPONSE_CODE.rassoc('OK').join)
        IO.copy_stream(file, socket)
      end
    else
      File.open('./public/404.html', "rb") do |file|
        socket.print content(content_type(path), 
        										 file.size, 
        										 RESPONSE_CODE.rassoc('Not Found').join)
        socket.print "\r\n"
        IO.copy_stream(file, socket)
      end
    end
	end

  def self.content_type(path)
    ext = File.extname(path).split('.').last
    CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
  end

  def self.content(type, size, code)
  	"HTTP/1.1 #{code}\r\n" + 
		"Content-Type: #{type}\r\n" +
		"Content-Length: #{size}\r\n" +
		"Connection: close\r\n\r\n"
  end
end