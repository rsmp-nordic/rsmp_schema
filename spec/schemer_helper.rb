require 'json_schemer'
require 'pp'

schema = Pathname.new('tlc/sxl.json')
$schemer = JSONSchemer.schema(schema)

def validate json
	if $schemer.valid? json
		nil
	else
	  errors = []
	  begin
	  	$schemer.validate(json).each do |item|
		  	errors ||= []
		    errors << [item['data_pointer'],item['type'],item['details']].compact
		  end
	  rescue
	  end
	  errors
	end
end