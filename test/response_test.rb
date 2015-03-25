require './lib/response.rb'
require 'minitest/autorun'
require 'net/http'

class TestResponse < MiniTest::Test

  def request(path)
    Net::HTTP.get_response(URI(path))
  end

  def test_content_type_mapping_html
    assert_equal 'text/html', request('http://localhost:2345/').response.content_type
  end

  def test_content_type_mapping_for_png
    assert_equal 'image/png', request('http://localhost:2345/test.png').response.content_type
  end

end