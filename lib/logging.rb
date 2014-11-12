require 'logger'
require 'yaml'

class Logging
	def self.setup
		log = Logger.new(load_output.nil? ? $stdout : load_output)
		log.level = set_level
		return log
	end

	def self.load_output
		File.open("config.yaml", "r") { |file| return YAML.load(file)['output'] }
	end

	def self.set_level
		File.open("config.yaml", "r") { |file| return YAML.load(file)['level'] }
	end
end