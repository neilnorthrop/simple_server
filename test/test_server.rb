require 'socket'
require 'net/http'
require './lib/server'
require 'minitest/autorun'

class TestServer < MiniTest::Test
  def test_hello_world_from_server
    response = Net::HTTP.get_response(URI('http://localhost:2345/'))
    assert_equal response.code, "200"
  end

  def test_content_type_mapping_html
    server = Server.new('localhost', 3456)
    path = 'http://www.example.com/index.html'
    assert_equal server.content_type(path), 'text/html'
  end

  def test_content_type_mapping_for_png
    server = Server.new('localhost', 3456)
    path = 'http://www.example.com/test.png'
    assert_equal server.content_type(path), 'image/png'
  end
end