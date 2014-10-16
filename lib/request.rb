class Request
	attr_reader :method, :resource, :version

	def initialize(method, resource, version)
		@method = method
		@resource = resource
		@version = version
	end

	def self.parse(string)
    pattern = /\A(?<method>\w+)\s+(?<resource>\S+)\s+(?<version>\S+)/
    match = pattern.match(string)
    Request.new(match["method"], match["resource"], match["version"])
  end
end