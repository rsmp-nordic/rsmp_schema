require 'json_schemer'

command = {
  "a" => "1",
  "b" => "200"
}

# try validating a message against our schema
schema = Pathname.new('test.json')
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


