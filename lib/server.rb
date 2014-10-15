require 'socket'

class Server
	attr_reader :port, :host, :server
	def initialize(host='localhost', port=2345)
		@port = 2345
		@host = 'localhost'
		@server = TCPServer.new(host, port)
	end

	def run
		loop do
			socket = server.accept
			puts socket
			request = socket.gets
			socket.puts request
			socket.puts "#{Time.now}"
			socket.close
		end
	end
end