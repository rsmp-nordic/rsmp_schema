require 'json_schemer'

schema = Pathname.new('command_request.json')
schemer = JSONSchemer.schema(schema)

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
      "cCI" => "M0001",
      "n" => "status",
      "cO" => "setValue",
      "v" => "YellowFlash"
    }
  ]
}

if schemer.valid? message
  puts 'ok'
else
  puts 'errors:'
  schemer.validate(message).each do |item|
    puts [item['data_pointer'],item['type'],item['details']].compact.join(' ')
  end
end


