require 'net/http'
require './lib/server'
require 'minitest/autorun'

class TestServer < MiniTest::Test
  def server
    Server.new('localhost', 2346)
  end

  def request(path)
    Net::HTTP.get_response(URI(path))
  end

  def test_hello_world_from_server
    assert_equal request('http://localhost:2345').code, "200"
  end

  def test_content_type_mapping_html
    assert_equal request('http://localhost:2345').response.content_type, 'text/html'
  end

  def test_content_type_mapping_for_png
    assert_equal request('http://localhost:2345/test.png').response.content_type, 'image/png'
  end

  def test_requested_file_joins_a_resource
    assert_equal server.clean_path('/index.html'), './public/index.html'
  end

  def test_requested_file_removes_double_periods_from_resource_but_keeps_directories
    assert_equal server.clean_path('/../../../hello/index.html'), './public/hello/index.html'
  end

  def test_requested_file_removes_double_periods_from_resource
    assert_equal server.clean_path('/../../hello/../index.html'), './public/index.html'
  end
end