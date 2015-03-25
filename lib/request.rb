class Request
  attr_reader :method, :resource, :version, :body

  WEB_ROOT = './public'

  def initialize(method, resource, version, body=nil)
    @method = method
    @resource = resource
    @version = version
    @body = body
  end

  def self.parse(string)
    pattern = /\A(?<method>\w+)\s+(?<resource>\S+)\s+(?<version>\S+)/
    match = pattern.match(string)
    Request.new(match["method"], clean_path(match["resource"]), match["version"], split_body(string))
  end

  def self.split_body(string)
    if string.split("\r\n\r\n")[1]
      return string.split("\r\n\r\n")[1]
    else
      return ""
    end
  end
  
  def self.clean_path(path)
    clean = []

    parts = path.split("/")
    parts.each do |part|
      next if part.empty? || part == '.'
      part == '..' ? clean.pop : clean << part
    end 
    File.join(WEB_ROOT, *clean)
  end
  
end