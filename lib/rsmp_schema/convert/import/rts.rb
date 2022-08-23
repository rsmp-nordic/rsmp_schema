# Imports an SXL from ReStructedText (RST) format.
# For exampple the raw version of the TLC SXL at:
# the page https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/blob/master/sxl_traffic_controller.md
#
# Note that the authoritative source for an SXL is usually YAML.
require 'yaml'
require 'json'
require 'fileutils'

module RSMP
  module Convert
    module Import
      module YAML

        def self.read path
          convert ::YAML.load_file(path)
        end

        def self.parse str
          convert ::YAML.load(str)
        end

        def self.convert yaml
          sxl = {
            meta: {},
            alarms: {},
            statuses: {},
            commands: {}
          }

          sxl[:meta] = yaml['meta']

          yaml['objects'].each_pair do |type,object|
            object["alarms"].each { |id,item| sxl[:alarms][id] = item } if object["alarms"]
            object["statuses"].each { |id,item| sxl[:statuses][id] = item } if object["statuses"]
            object["commands"].each { |id,item| sxl[:commands][id] = item } if object["commands"]
          end
					
					@alarms = {}
					@statuses = {}
					@commands = {}

					type = nil
					code = nil
					description = nil
					collect = false
					table = false
					args = []
					text = ''
					state = nil

					yaml.each_line do |line|
						if state == nil && line =~ /^# Alarms/
							state = :alarm_section
							p state
						elsif (state == :alarm_section || state == :alarm_table) &&line =~ /^\|.+\|$/
							state = :alarm_table
							
							a = line.split('|')
							id = a[2].match(/A\d{3,5}/)
							if id
								id = id.to_s
								@alarms[id] = {text:a[3]}
							end
						elsif state == :alarm_table && !(line =~ /^\|.+\|$/)
							state = nil
						elsif collect == false && line =~ /^### ([SAM])([0-9]{1,5})/
							collect = true
							table = false
							type = $1
							code = $2
							args = []
							text = ''
						elsif collect == true && table == false && !(line =~ /^\|.+\|$/)
							text.concat line
						elsif collect == true && line =~ /^\|.+\|$/
							table = true
							a = line.split('|')
							if type == 'S' || type == 'A'
								args << {name:a[1],type:a[2],values:a[3],desc:a[4]}
							elsif type == 'M'
								args << {name:a[1],command:a[2],type:a[3],values:a[4],desc:a[5]}
							end
						elsif table == true && !(line =~ /^\|.+\|$/)
							table = false
							collect = false
							id = "#{type}#{code}"

							item = {text:text.strip, args:args[2,args.size]}
							if type == 'S'
								@statuses[id] = item
							elsif type == 'A'
								@alarms[id] = item
							elsif type == 'M'
								@commands[id] = item
							end
						end
					end
 

          sxl
        end
      end

    end
  end
end

