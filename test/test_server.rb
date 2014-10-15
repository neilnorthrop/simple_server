require 'socket'
require 'net/http'
require './lib/server'
require 'minitest/autorun'

class TestServer < MiniTest::Test
  def test_hello_world_from_server
    response = Net::HTTP.get(URI('http://localhost:2345/'))
    assert_equal response, 'Hello World'
  end
end