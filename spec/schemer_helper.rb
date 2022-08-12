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

def validate json, schema, versions = :all
	validate_variations( {all:json}, schema, versions )
end

def validate_variations json_variations, schema, versions = :all
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
		json_variation = json_variations[:all] || json_variations[version]
		if schemer.valid? json_variation
			next
		else
		  errors ||= {}
		  begin
		  	schemer.validate(json_variation).each do |item|
			  	errors[version] ||= []
			    errors[version] << [item['data_pointer'],item['type'],item['details']].compact
			  end
		  end
		end
	end
	# done if no errors
	return nil unless errors

	# if all versions has the same errors, then simplify and just return a value
	if errors && errors.any?
		if errors.size == schemers.size && errors.values.uniq.size == 1
			return errors.values.first
		end
	end

	# return errors, grouped by versions with the same error
	# e.g. {'1.1' => 'A', 1.2 => 'A', '1.3' => 'B' }
	# is transformed to { ['1.1','1.2'] => 'A', '1.3' => 'B'}
	errors.
		keys.
		group_by {|version| errors[version] }.
		transform_values {|arr| arr.size == 1 ? arr.first : arr }. 
		invert
end
