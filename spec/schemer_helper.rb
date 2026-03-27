require 'json_schemer'
require 'pp'

SCHEMERS = {
  'core' => {},
  'tlc' => {}
}.freeze

[
  '3.1.2',
  '3.1.3',
  '3.1.4',
  '3.1.5',
  '3.2.0',
  '3.2.1',
  '3.2.2'
].each do |version|
  SCHEMERS['core'][version] = JSONSchemer.schema(Pathname.new("schemas/core/#{version}/rsmp.json"))
end

[
  '1.0.7',
  '1.0.8',
  '1.0.9',
  '1.0.10',
  '1.0.13',
  '1.0.14',
  '1.0.15',
  '1.1.0',
  '1.2.0',
  '1.2.1'
].each do |version|
  SCHEMERS['tlc'][version] = JSONSchemer.schema(Pathname.new("schemas/tlc/#{version}/rsmp.json"))
end

def validate(json, schema, versions = :all)
  validate_variations({ all: json }, schema, versions)
end

def validate_variations(json_variations, schema, versions = :all)
  raise "Unknown schema: #{schema}" unless SCHEMERS[schema.to_s]

  version_list = build_version_list(schema, versions)
  schemers = build_schemers(schema, version_list)
  errors = collect_schema_errors(json_variations, schemers)
  simplify_errors(errors, schemers)
end

def build_version_list(schema, versions)
  if versions == :all
    SCHEMERS[schema.to_s].keys
  elsif versions.is_a? String
    # convert a string like '>=3.1.3' to an array of matching version strings,
    # by using the Gem::Requirement class.
    # This has nothing to do with gems, we just use the version matching helper.
    requirement = Gem::Requirement.new(versions)
    SCHEMERS[schema.to_s].keys.select { |v| requirement.satisfied_by?(Gem::Version.new(v)) }
  else
    versions
  end
end

def build_schemers(schema, version_list)
  version_list.each_with_object({}) do |version, schemers|
    raise "Unknown schema version: #{schema} #{version}" unless SCHEMERS[schema.to_s][version.to_s]

    schemers[version] = SCHEMERS[schema][version]
  end
end

def collect_schema_errors(json_variations, schemers)
  errors = nil
  schemers.each_pair do |version, schemer|
    json_variation = json_variations[:all] || json_variations[version]
    next if schemer.valid? json_variation

    errors ||= {}

    schemer.validate(json_variation).each do |item|
      errors[version] ||= []
      errors[version] << [item['data_pointer'], item['type'], item['details']].compact
    end
  end
  errors
end

def simplify_errors(errors, schemers)
  return nil unless errors
  return errors.values.first.sort if all_same_errors?(errors, schemers)

  group_errors_by_version(errors)
end

def all_same_errors?(errors, schemers)
  errors.any? && errors.size == schemers.size && errors.values.uniq.size == 1
end

def group_errors_by_version(errors)
  # return errors, grouped by versions with the same error
  # e.g. {'1.1.0' => 'A', '1.2.0' => 'A', '1.3.0' => 'B' }
  # is transformed to { ['1.1.0','1.2.0'] => 'A', '1.3.0' => 'B'}
  errors
    .keys
    .group_by { |version| errors[version] }
    .transform_values { |arr| arr.size == 1 ? arr.first : arr }
    .invert
    .transform_values! { |arr| arr.uniq.sort }
end
