require 'rsmp_schema'

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
      "cCI" => "M0002",
      "n" => "timeplan",
      "cO" => "setPlan",
      "v" => "1"
    }
  ]
}

# load schemas
RSMP::Schema.setup

# validating a message against core and tlc schemas 
result = RSMP::Schema.validate( message, core: "3.2.1", tlc: "1.2.1" )
if result == nil
  puts 'ok'
else
  puts "failed: #{result.inspect}"
end
