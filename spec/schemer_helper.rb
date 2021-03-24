require 'json_schemer'
require 'pp'

$schema_core = Pathname.new('schema/core/rsmp.json')
$schemer_core = JSONSchemer.schema($schema_core)

#schema_tlc = Pathname.new('schema/tlc/sxl.json')
#schemer_tlc = JSONSchemer.schema(schema_tlc)

def validate json, schemer=$schemer_core
  if schemer.valid? json
    nil
  else
    errors = []
    begin
      schemer.validate(json).each do |item|
        errors ||= []
        errors << [item['data_pointer'],item['type'],item['details']].compact
      end
    end
    errors
  end
end
