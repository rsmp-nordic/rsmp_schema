require 'json_schemer'
require 'pp'

$schemers = {
	'core' => {},
	'tlc' => {}
}

[
	'3.1.1',
	'3.1.2',
	'3.1.3',
	'3.1.4',
	'3.1.5'
].each do |version|
	$schemers['core'][version] = JSONSchemer.schema( Pathname.new("schemas/core/#{version}/rsmp.json") )
end

[
	'1.0.7',
	'1.0.8',
	'1.0.9',
	'1.0.10',
	'1.0.13',
	'1.0.14',
	'1.0.15'
].each do |version|
	$schemers['tlc'][version] = JSONSchemer.schema( Pathname.new("schemas/tlc/#{version}/sxl.json") )
end

def validate json, schema, versions
	raise RuntimeError.new("Unknown schema: #{schema}") unless $schemers[schema.to_s]
	
	if versions == :all
		versions = $schemers[schema.to_s].keys
	elsif versions.is_a? String
		versions = [versions]
	end

	schemers = {}
	versions.each do |version|
		raise RuntimeError.new("Unknown schema version: #{schema} #{version}") unless $schemers[schema.to_s][version.to_s]
		schemers[version] = $schemers[schema][version]
	end

	errors = nil
	schemers.each_pair do |version,schemer|
		if schemer.valid? json
			next
		else
		  errors ||= {}
		  begin
		  	schemer.validate(json).each do |item|
			  	errors[version] ||= []
			    errors[version] << [item['data_pointer'],item['type'],item['details']].compact
			  end
		  end
		end
	end
	if errors && errors.any?
		if errors.values.uniq.size == 1
			errors = {all: errors.values.first}
		end
	end
	errors
end