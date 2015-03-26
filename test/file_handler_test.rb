require 'net/http'
require 'minitest/autorun'
require './lib/file_handler.rb'

class FileHandlerTest < MiniTest::Test

  def setup
    @file_handler = FileHandler.new
  end

  def test_get_content_type
    assert_equal 'text/html', @file_handler.get_content_type('./public/index.html')
    assert_equal 'application/octet-stream', @file_handler.get_content_type('./public/index')
  end

  def test_handle_file_found
    @file_handler.handle_file('./test/test.html')
    assert_equal '200/OK', @file_handler.response_code
  end

  def test_handle_file_not_found
    @file_handler.handle_file('./test/hello.index')
    assert_equal '404/Not Found', @file_handler.response_code
  end

end
