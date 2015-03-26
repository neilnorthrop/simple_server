class FileHandler
  attr_accessor :path, :body, :response_code, :content_type, :file_size

  CONTENT_TYPE_MAPPING = {
    'html' => 'text/html',
    'txt'  => 'text/plain',
    'png'  => 'image/png',
    'jpg'  => 'image/jpg',
    'haml' => 'text/html'
  }

  RESPONSE_CODE = {
    '100' => 'Continue',
    '200' => 'OK',
    '201' => 'Created',
    '202' => 'Accepted',
    '400' => 'Bad Request',
    '403' => 'Forbidden',
    '404' => 'Not Found',
    '500' => 'Internal Server Error',
    '502' => 'Bad Gateway'
  }

  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

  DEFAULT_INDEX = 'index.html'
  NOT_FOUND = './public/404.html'

  def initialize(path)
    @path          = path
    @body          = ""
    @response_code = ""
    @content_type  = ""
    @file_size     = 0
  end

  def build_body(path)
    File.open(path, "rb") do |file|
      @body = file
      @file_size = file.size
    end
  end

  def get_content_type(path)
    ext = File.extname(path).split('.').last
    CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
  end

  def handle_file
    @path = File.join(@path, DEFAULT_INDEX) if File.directory?(@path)
    if File.exist?(@path) && !File.directory?(@path)
      build_body(@path)
      @response_code = RESPONSE_CODE.rassoc('OK').join("/")
      @content_type = get_content_type(@path)
    else
      @response_code = RESPONSE_CODE.rassoc('Not Found').join("/")
    end
  end

end
