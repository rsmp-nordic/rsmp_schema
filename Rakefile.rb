# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

	# task for adding scheme. run this like:
	# schema=core version=3.1.3 rake schema:regenerate

task :regenerate do
#   schema = ENV['type']
#   version = ENV['version']
#   raise ArgumentError.new("type argument is missing") unless /\w+/ =~ type
#   raise ArgumentError.new("version argument must be in the format <x.y.z>") unless /\d+\.\d+\.\d+/ =~ version
  
  Dir.glob('schemas/tlc/*/sxl.json').each do |path|
    sxl = RSMP::Convert::Import::YAML.read path
    RSMP::Convert::Export::JSONSchema.write sxl, File.dirname(path)
  end
end
