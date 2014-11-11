require 'logger'
require 'yaml'

class Logging
	def self.setup
		log = Logger.new(output.nil? ? $stdout : output)
	end

	def self.output
		YAML.load(File.open('config.yaml'))['output']
	end

	def self.set_level
		YAML.load(File.open('config.yaml'))['level']
	end
end