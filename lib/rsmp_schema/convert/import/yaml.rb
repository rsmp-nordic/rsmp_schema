# Import SXL from YAML format

require 'yaml'
require 'json'
require 'fileutils'

module RSMP
  # Namespace for SXL format conversion tools.
  module Convert
    # Handles importing SXL definitions.
    module Import
      # Reads SXL definitions from YAML files.
      module YAML
        def self.read(path)
          convert ::YAML.load_file(path)
        end

        def self.parse(str)
          convert ::YAML.safe_load(str)
        end

        def self.convert(yaml)
          sxl = {
            meta: {},
            alarms: {},
            statuses: {},
            commands: {}
          }

          sxl[:meta] = yaml['meta']

          yaml['objects'].each_pair do |_type, object|
            object['alarms']&.each { |id, item| sxl[:alarms][id] = item }
            object['statuses']&.each { |id, item| sxl[:statuses][id] = item }
            object['commands']&.each { |id, item| sxl[:commands][id] = item }
          end
          sxl
        end
      end
    end
  end
end
