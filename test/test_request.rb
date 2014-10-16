require './lib/request'
require 'minitest/autorun'

class TestRequest < MiniTest::Test
  def test_that_request_parser_returns_method
    match = Request.parse('GET /index.html HTTP/1.1')
    assert_equal match.method, 'GET' 
    assert_equal match.resource, '/index.html'
    assert_equal match.version, 'HTTP/1.1'
  end

  def test_that_request_parser_ignores_body
    match = Request.parse("GET /index.html HTTP/1.1\n Accept: This and that\n Body: GET /index2.html HTTP/1.90")
    assert_equal match.method, 'GET'
    assert_equal match.resource, '/index.html'
    assert_equal match.version, 'HTTP/1.1'
  end
end