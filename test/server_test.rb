require 'net/http'
require './lib/simple_server'
require 'minitest/autorun'

class TestSimpleServer < MiniTest::Test

  def request(path)
    Net::HTTP.get_response(URI(path))
  end

  def test_hello_world_from_server
    assert_equal "200", request('http://localhost:2345').code
  end

  def test_404_from_server
    assert_equal "404", request('http://localhost:2345/bad_request').code
  end

  def test_content_type_mapping_html
    assert_equal 'text/html', request('http://localhost:2345/').response.content_type
  end

  def test_content_type_mapping_for_png
    assert_equal 'image/png', request('http://localhost:2345/test.png').response.content_type
  end

end
