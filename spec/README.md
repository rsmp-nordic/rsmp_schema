# About
JSON Schema for RSMP messages. The schema can be used to automatically validate RSMP messages.

The schema is still experimental, and only covers a few select messages within in the SXL for Trafic Light Controllers:
https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights

However, the structure is setup to allow more message to be easilty added to the schema.

More about JSON Schema:
https://json-schema.org/

## Schema organisation
The schema is split into multiple files to enable reuse.

An SXL defines massages specific to a particular type of equipment, but they all rely on the core part of the RSMP specification.

To validate a message against a particular SXL, use the sxl.json file in the relevant folder.
For example, to validate agaisnt the SXL for Trafic Light Controllers (TLCs), include 'tcl/sxl.json'

This main sxl.json file includes the core.json part, which contains validations for the RSMP core elements.
Depending on the message type, commands.json, alarms.json, etc will be included. This file in turn looks at command/status/alarm code and includes the file describing the detailed parameters, arguments, etc.

For example, validating a CommandRequest M0001 message will include these parts:

sxl.json
	core.json
	commands.json
	  M0001.json

## Example usage
To validate a JSON message with Ruby using the json_schemer gem:

```Ruby
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
      "cCI" => "M0001",
      "n" => "status",
      "cO" => "setValue",
      "v" => "YellowFlash"
    }
  ]
}

# try validating a message against our schema
schema = Pathname.new('tlc/sxl.json')
schemer = JSONSchemer.schema(schema)
puts schemer.valid? message     # => true
```

## RSpec tests
The reposity includes RSpec test that checks the schema, by testing the result validating a set of valid and invalid RSMP messages using the json_schemer gem.

```
$ bundle              # install gems
$ bundle exec rspec   # run rspec tests
``
