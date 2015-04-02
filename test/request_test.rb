require './lib/request'
require 'minitest/autorun'

class TestRequest < MiniTest::Test

  def test_that_request_parser_returns_method
    match = Request.parse('GET /index.html HTTP/1.1')
    assert_equal match.method, 'GET'
    assert_equal match.resource, './public/index.html'
    assert_equal match.version, 'HTTP/1.1'
  end

  def test_that_request_parser_ignores_body
    match = Request.parse("GET /index.html HTTP/1.1\n Accept: This and that\n Body: GET /index2.html HTTP/1.90")
    assert_equal match.method, 'GET'
    assert_equal match.resource, './public/index.html'
    assert_equal match.version, 'HTTP/1.1'
  end

  def test_requested_file_joins_a_resource
    assert_equal './public/index.html', Request.clean_path('/index.html')
  end

  def test_requested_file_keeps_directories
    assert_equal './public/hello/index.html', Request.clean_path('/../../../hello/index.html')
  end

  def test_requested_file_removes_change_directories
    assert_equal './public/index.html', Request.clean_path('/../../hello/../index.html')
  end

  def test_split_body
    expected_string = "this is the body"
    actual_string = "GET / HTTP/1.1\r\nUser-Agent: curl/7.37.1\r\nHost: localhost:2345\r\nAccept: */*\r\n\r\nthis is the body"
    assert_equal expected_string, Request.split_body(actual_string)
  end

  def test_split_body_without_a_body
    expected_string = ""
    actual_string = "GET / HTTP/1.1\r\nUser-Agent: curl/7.37.1\r\nHost: localhost:2345\r\n\r\n"
    assert_equal expected_string, Request.split_body(actual_string)
  end

end
