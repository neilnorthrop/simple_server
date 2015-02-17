class Request
	attr_reader :method, :resource, :version, :body

	def initialize(method, resource, version, body=nil)
		@method = method
		@resource = resource
		@version = version
		@body = body
	end

	def self.parse(string)
    pattern = /\A(?<method>\w+)\s+(?<resource>\S+)\s+(?<version>\S+)/
    match = pattern.match(string)
    Request.new(match["method"], match["resource"], match["version"], split_body(string))
  end

  def self.split_body(string)
  	if string.split("\r\n\r\n")[1]
  		return string.split("\r\n\r\n")[1]
  	else
  		return ""
  	end
  end
end