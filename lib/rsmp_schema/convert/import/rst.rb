# Imports an SXL from ReStructedText (RST) format.
# For exampple the raw version of the TLC SXL at:
# the page https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights/blob/master/sxl_traffic_controller.md
#
# Note that the authoritative source for an SXL is usually YAML.
require 'yaml'
require 'json'
require 'fileutils'

module RSMP::Convert::Import::RST
  def self.read path
    convert File.read(path)
  end

  def self.convert rst
    sxl = {
      meta: {},
      alarms: {},
      statuses: {},
      commands: {}
    }
    result = /
	    ^Alarms\n
	    \-+\n
			(.*)
	    ^Status\n
	    \-+\n
			(.*)
	    ^Commands\n
	    \-+\n
			(.*)
		/xm.match(rst)
		convert_alarms result[1]
		convert_statuses result[2]
		convert_commands result[3]
	end

	def self.convert_alarms rst
		rst.strip.split(/
			(?=
				A\d{4}\n 							# A0001
				\^+\n 								# ^^^^^
			)
		/x)[1..].each do |alarm|
			self.convert_alarm alarm.strip
		end
	end

	def self.convert_alarm rst		
		result = 
		/											# try matching with table
			(A\d{4})\n 							# A0001
			\^+\n            				# ^^^^^
			(.+)  									# Serious hardware error
			^(
				\.\.\sfigtable::\n   	# .. figtable::
				.+										#    :nofig:
			) 										
		/xm.match(rst) ||
		/											# try matching without table
			(A\d{4})\n 							# A0001
			\^+\n            				# ^^^^^
			(.+)  									# Serious hardware error
		/xm.match(rst)

		code = result[1].strip
		description = result[2].strip
		
		if result[3]
			self.parse_table result[3].strip
		end
	end

	def self.parse_table rst
		puts rst
		puts
	end

	def self.convert_statuses rst
	end

	def self.convert_commands rst
	end
end


