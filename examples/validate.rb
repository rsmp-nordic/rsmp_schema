require 'json_schemer'

message = {
  "mType" => "rSMsg",
  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
  "type" => "CommandRequest",
  "siteId" => [
    { "sId" => "RN+SI0001" }
  ],
  "cId" => "O+14439=481WA001",
  "arg" => [
    {
      "n" => "timeplan",
      "cO" => "setPlan",
      "v" => "1"
    }
  ]
}

# try validating a message against our schema
schema_core = Pathname.new('schema/core/rsmp.json')
schemer_core = JSONSchemer.schema(schema_core)

def validate message, schemer
  if schemer.valid? message
    'ok'
  else
    schemer.validate(message).map do |item|
      [item['data_pointer'],item['type'],item['details']].compact.join(' ')
    end
  end
end

puts "core: #{validate message, schemer_core}"

