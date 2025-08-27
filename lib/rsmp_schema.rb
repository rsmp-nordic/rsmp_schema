require 'yaml'
require 'json_schemer'

# Define module hierarchy first
module RSMP
end

require 'rsmp_schema/error'
require 'rsmp_schema/schema'
require 'rsmp_schema/convert/import/yaml'
require 'rsmp_schema/convert/export/json_schema'
require 'rsmp_schema/version'

RSMP::Schema.setup