require 'net/http'
require './lib/simple_server'
require 'minitest/autorun'

class TestSimpleServer < MiniTest::Test
  def server
    SimpleServer.new('localhost', 2346)
  end

  def request(path)
    Net::HTTP.get_response(URI(path))
  end

  def test_hello_world_from_server
    assert_equal request('http://localhost:2345').code, "200"
  end

  def test_404_from_server
    assert_equal request('http://localhost:2345/bad_request').code, "404"
  end
end