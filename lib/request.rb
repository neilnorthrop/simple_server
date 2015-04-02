require_relative 'file_handler'
require_relative 'response'

class Request
  attr_reader :method, :resource, :version, :body

  WEB_ROOT = './public'

  def initialize
    @method = method
    @resource = resource
    @version = version
    @body = body
  end

  def build(string)
    request = parse(string)
    file_handler = FileHandler.new(request[:resource])
    file_handler.handle_file(file_handler.path)
    return Response.build_header(file_handler)
  end

  def parse(string)
    pattern = /\A(?<method>\w+)\s+(?<resource>\S+)\s+(?<version>\S+)/
    match = pattern.match(string)
    return { :method => match["method"], :resource => clean_path(match["resource"]), :version => match["version"], :body => split_body(string) }
  end

  def split_body(string)
    if string.split("\r\n\r\n")[1]
      return string.split("\r\n\r\n")[1]
    else
      return ""
    end
  end

  def clean_path(path)
    clean = []

    parts = path.split("/")
    parts.each do |part|
      next if part.empty? || part == '.'
      part == '..' ? clean.pop : clean << part
    end
    File.join(WEB_ROOT, *clean)
  end

end
