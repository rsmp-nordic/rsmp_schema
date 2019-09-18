<<-EOF

JSON Schema allows sevaral parts/files to be combined with "allOff",
but "additionalProperties":false will not work as expected,
and is threrefore left out for now.

Draft-8 of JSON Schema will include "unevaluatedProperties" which can be used to
solve this:

https://github.com/json-schema-org/json-schema-spec/issues/556
https://github.com/json-schema-org/json-schema-spec/milestone/6

SXL schema layout:

rsmp
  base
  allOf
    if ack
      ref ack
    if notAck
      ref notAck
    if version
      ref version
    if watchdog
      ref watchdog
    if command
      ref command base
      ref command sxl
    if status
      ref status base
      ref status sxl
    if alarm
      ref alarm base
      ref alarm sxl

sxl
  definitions
    sxl_command
      allOf
        if M1
          ...
        if M2
          ...
    sxl_status
      ...
    sxl_alarm
      ...

  ref rsmp
EOF

require 'json_schemer'

 version = {
  "mType" => "rSMsg",
  "mId" => "a28e94b9-05c7-41bb-8f8b-54693adc9698",
  "siteId" => [
    { "sId" => "RN+SI0001" }
  ],
  "type" => "Version",
  "RSMP" => [
    { "vers" => "3.1.1" },
    { "vers" => "3.1.2" },
    { "vers" => "3.1.3" },
    { "vers" => "3.1.4" }
  ],
  "SXL" => "1.1"
}

ack = {
  "mType" => "rSMsg",
  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
  "siteId" => [
    { "sId" => "RN+SI0001" }
  ],
  "type" => "MessageAck",
  "oMId" => "92b9706d-0466-4518-8663-00b9690e9c41"
}

status = {
  "mType" => "rSMsg",
  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
  "type" => "StatusRequest",
  "siteId" => [
    { "sId" => "RN+SI0001" }
  ],
  "cId" => "O+14439=481WA001"
}

command = {
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
      "n" => "statusx",
      "cO" => "setValue",
      "v" => "YellowFlash"
    }
  ]
}

# try validating a message against our schema
schema = Pathname.new('tlc/sxl.json')
schemer = JSONSchemer.schema(schema)
message = command
if schemer.valid? message
  puts 'ok'
else
  puts 'errors:'
  schemer.validate(message).each do |item|
    puts [item['data_pointer'],item['type'],item['details']].compact.join(' ')
  end
end


