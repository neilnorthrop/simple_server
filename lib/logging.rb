require 'logger'
require 'yaml'

module Logging
	extend self
	def setup
		Logger.new(load['output'].nil? ? $stdout : load['output'])
	end

	def load
		YAML.load(File.open('config.yaml'))
	end
end