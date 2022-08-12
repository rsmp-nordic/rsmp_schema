# About
JSON Schema for RSMP messages. The schema can be used to automatically validate RSMP messages.

The schema so far covers the core specifiation and the SXL for Trafic Light Controllers:
https://github.com/rsmp-nordic/rsmp_core
https://github.com/rsmp-nordic/rsmp_sxl_traffic_lights

More about JSON Schema:
https://json-schema.org/

## Schema organisation
The schema is split into multiple files to enable reuse.

An SXL defines massages specific to a particular type of equipment, but they all rely on the core part of the RSMP specification.

To validate a message against a particular SXL, use the sxl.json file in the relevant folder.
For example, to validate against the SXL for Trafic Light Controllers (TLCs), include 'tcl/sxl.json'

This main sxl.json file includes the core.json part, which contains validations for the RSMP core elements.
Depending on the message type, commands.json, alarms.json, etc. will be included. That file in turn looks at the command/status/alarm code and includes the file describing the detailed parameters, arguments, etc.

For example, validating a CommandRequest M0001 message will include these parts:

```
sxl.json
  core.json
  commands.json
    M0001.json
```

## Example usage
To validate a JSON message with Ruby using the json_schemer gem:

```ruby
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
The reposity includes RSpec test that checks the schema, by testing the result of validating a set of valid and message RSMP messages using the json_schemer gem.

This is useful when developing the schema, to ensure it validates correctly.


```
$ bundle              # install gems
$ bundle exec rspec   # run rspec tests
```

## Schema generation
Note that the SXL JSON schemas are generated automatically from an authoritative YAML file, and should therefore not be edited by hand. Instead, edit the YAML source and regenerate the schema files.
