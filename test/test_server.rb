require 'socket'
require './lib/server'
require 'minitest/autorun'

class TestServer < MiniTest::Test
	def test_server_hello_world
		server = Server.new
		assert server
	end
end