require 'socket'

class Response

  CONTENT_TYPE_MAPPING = {
    'html' => 'text/html',
    'txt'  => 'text/plain',
    'png'  => 'image/png',
    'jpg'  => 'image/jpg'
  }

  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

	def self.build_response(path, socket)
		request(path, socket)
	end

  def self.content_type(path)
    ext = File.extname(path).split('.').last
    CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
  end

  def self.request(path, socket)
    if File.exist?(path) && !File.directory?(path)
      File.open(path, "rb") do |file|
        socket.print "HTTP/1.1 200 OK\r\n" +
                     "Content-Type: #{content_type(file)}\r\n" +
                     "Content-Length: #{file.size}\r\n" +
                     "Connection: close\r\n"
        socket.print "\r\n"
        IO.copy_stream(file, socket)
      end
    else
      File.open('./public/404.html', "rb") do |file|
        socket.print "HTTP/1.1 404 Not Found\r\n" +
                     "Content-Type: #{content_type(file)}\r\n" +
                     "Content-Length #{file.size}\r\n" +
                     "Connection: close\r\n"
        socket.print "\r\n"
        IO.copy_stream(file, socket)
      end
    end
  end
end