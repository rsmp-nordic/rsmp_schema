# Imports an SXL from YAML format

require 'yaml'
require 'json'
require 'fileutils'

class SXLImporter

	def initialize
		@base_path = 'schema/tlc'

		@json_options = {
		  array_nl: "\n",
		  object_nl: "\n",
		  indent: '  ',
		  space_before: ' ',
		  space: ' '
		}
	end

	def write_json item, path
		output_path = File.join(@base_path,path)
		FileUtils.mkdir_p File.dirname(output_path)		# create folders if needed
		file = File.open(output_path, 'w+')						# w+ means truncate or create new file 
		file.puts JSON.generate(item,@json_options)
	end

	def build_value item
		out = {}
		
		if item['description']
			out["description"] = item['description']
		end

		case item['type']
		when "string", "base64"
			out["type"] = "string"
		when "boolean"
			out["type"] = "boolean"
		when "timestamp"
			out["$ref"] = "../../core/definitions.json#/timestamp"
		when "integer", "ordinal", "unit", "scale", "long"
			out["$ref"] = "../../core/definitions.json#/integer"
		when "integer_list"
			out["$ref"] = "../../core/definitions.json#/integer_list"
		when "boolean_list"
			out["$ref"] = "../../core/definitions.json#/boolean_list"
		else
			out["type"] = "string"
		end

		if item["pattern"]
			out["pattern"] = item["pattern"]
		elsif item["values"]		# ignore values if there's a pattern
			out["enum"] = item["values"].keys.sort
		end

		out
	end

	def build_item item, field='v'
		json = { "allOf" => [ { "description" => item['description'] } ] }
		if item['arguments']
			json["allOf"].first["properties"] = { "n" => { "enum" => item['arguments'].keys.sort } }
			item['arguments'].each_pair do |key,argument|
				json["allOf"] << {
					"if" => { "required" => ["n"], "properties" => { "n" => { "const" => key }}},
			    "then" => { "properties" => { field => build_value(argument) } }
				}
			end
		end
		json
	end

	def write_alarms
		items = @alarms
		list = items.keys.sort.map do |key|
      {
        "if" => { "required" => ["aCId"], "properties" => { "aCId" => { "const" => key }}},
        "then" => { "$ref" => "#{key}.json" }
      }
    end
		json = {
		  "properties" => { 
		    "aCId" => { "enum" => items.keys.sort },
		    "rvs" => { "items" => { "allOf" => list } }
		  }
		}
		write_json json, 'alarms/alarms.json'
		items.each_pair { |key,item| write_alarm key, item }
	end

	def write_alarm key, item
		json = build_item item
		write_json json, "alarms/#{key}.json"
	end

	def write_statuses
		items = @statuses
		list = [ { "properties" => { "sCI" => { "enum"=> items.keys.sort }}} ]
		items.keys.sort.each do |key|
	    list << {
	      "if"=> { "required" => ["sCI"], "properties" => { "sCI"=> { "const"=> key }}},
	      "then" => { "$ref" => "#{key}.json" }
	  	}
	  end
		json = { "properties" => { "sS" => { "items" => { "allOf" => list }}}}
		write_json json, 'statuses/statuses.json'
		items.each_pair { |key,item| write_status key, item }
	end

	def write_status key, item
		json = build_item item, 's'
		write_json json, "statuses/#{key}.json"
	end

	def write_commands
		items = @commands
		list = [ { "properties" => { "cCI" => { "enum"=> items.keys.sort }}} ]
		items.keys.sort.each do |key|
			list << {
	      "if" => { "required" => ["cCI"], "properties" => { "cCI"=> { "const"=> key }}},
	      "then" => { "$ref" => "#{key}.json" }
	    }
	  end
		json = { "items" => { "allOf" => list }}
		write_json json, 'commands/commands.json'

		json = { "properties" => { "arg" => { "$ref" => "commands.json" }}}
		write_json json, 'commands/command_requests.json'

		json = { "properties" => { "rvs" => { "$ref" => "commands.json" }}}
		write_json json, 'commands/command_responses.json'

		items.each_pair { |key,item| write_command key, item }
	end

	def write_command key, item
		json = build_item item
		json["allOf"].first["properties"]['cO'] = { "const" => item['command'] }
		write_json json, "commands/#{key}.json"
	end

	def read_yaml yaml_path
		@alarms = {}
		@statuses = {}
		@commands = {}

		yaml = YAML.load_file yaml_path
		yaml['objects'].each_pair do |type,object|	
			object["alarms"].each { |id,item| @alarms[id] = item }
			object["statuses"].each { |id,item| @statuses[id] = item }
			object["commands"].each { |id,item| @commands[id] = item }
		end
	end

	def write_root
		json = {
			"description"=> "A schema validatating message against the RSMP SXL for Traffic Light Controllers",
		  "allOf" => [
		  	{
		  		"$ref"=> "../core/rsmp.json"
				},
			  {
			    "if" => { "required" => ["type"], "properties" => { "type" => { "const" => "CommandRequest" }}},
			    "then" => { "$ref" => "commands/command_requests.json" }
			  },
			  {
			    "if" => { "required" => ["type"], "properties" => { "type" => { "const" => "CommandResponse" }}},
			    "then" => { "$ref" => "commands/command_responses.json" }
			  },
			  {
			    "if" => { "required" => ["type"], "properties" => { "type" => { "enum" => ["StatusRequest","StatusResponse","StatusSubscribe","StatusUnsubscribe","StatusUpdate"] }}},
			    "then" => { "$ref" => "statuses/statuses.json" }
			  },
			  {
			    "if" => { "required" => ["type"], "properties" => { "type" => { "const" => "Alarm" }}},
			    "then" => { "$ref" => "alarms/alarms.json" }
			  }
		  ]
		}
		write_json json, "sxl.json"		
	end

	def write_schema
		write_root

		write_alarms
		write_statuses
		write_commands
	end

	def import_yaml yaml_path
		read_yaml yaml_path
		write_schema
	end
end


yaml_path = ARGV[0] || 'sxl.yaml'
unless File.exists? yaml_path
	puts "Input file #{yaml_path} not found"
	exit
end

SXLImporter.new.import_yaml yaml_path
