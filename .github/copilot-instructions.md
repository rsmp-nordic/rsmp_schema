# RSMP Schema Ruby Gem

RSMP Schema is a Ruby gem that provides JSON Schema validation for RSMP (Road Side Message Protocol) messages. The schema covers both the core RSMP specification and SXL (Signal Exchange List) for Traffic Light Controllers.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

Bootstrap, build, and test the repository using mise:

### Using mise
- Install mise: https://mise.jdx.dev/
- Install Ruby version from .tool-versions: `mise install`
- Install dependencies: `bundle install` -- takes 10-15 seconds. NEVER CANCEL. Set timeout to 60+ seconds.
- Run tests: `bundle exec rspec` -- takes 2 seconds. NEVER CANCEL. Set timeout to 30+ seconds.

## Environment Setup Commands

### Using mise

```bash
# Install mise (if not already installed)
# Follow instructions at https://mise.jdx.dev/

# Install Ruby version specified in .tool-versions
mise install

# Install all dependencies
bundle install
```

## Running Tests

Run the complete test suite:
```bash
# Test command takes approximately 2 seconds
bundle exec rspec
```

The test suite includes comprehensive RSpec examples covering:
- Core RSMP message validation
- Traffic Light Controller SXL validation  
- Command request/response validation
- Status and alarm message validation

All tests should pass on a clean repository.

## CLI Tool Usage

The gem provides a CLI tool for converting YAML SXL files to JSON Schema:

```bash
# Show available commands
bundle exec exe/rsmp_schema --help

# Convert YAML SXL to JSON Schema
bundle exec exe/rsmp_schema convert -i <input.yaml> -o <output_directory>

# Example: Convert TLC SXL
bundle exec exe/rsmp_schema convert -i schemas/tlc/1.2.1/sxl.yaml -o /tmp/output
```

## Schema Regeneration

Regenerate all TLC JSON schemas from their YAML sources:

```bash
# Regenerates all schemas in schemas/tlc/*/sxl.yaml
bundle exec rake regenerate
```

**WARNING**: This destructively overwrites all generated JSON schema files. Core schemas are not affected as they are hand-maintained.

## Validation

Always manually validate changes by running message validation scenarios:

```bash
# Test validation with corrected example script
cd /path/to/repo
sed 's|schema/tlc/1.2.1/rsmp.json|schemas/tlc/1.2.1/rsmp.json|' examples/validate.rb | bundle exec ruby
```

Expected output: `ok` (indicates successful validation)

## Repository Structure

Key directories and files:
- `lib/rsmp_schema/` - Main gem code
- `lib/rsmp_schema/cli.rb` - CLI tool implementation  
- `lib/rsmp_schema/convert/` - YAML to JSON Schema conversion
- `exe/rsmp_schema` - Executable CLI wrapper
- `spec/` - RSpec test files
- `schemas/core/` - Hand-maintained core RSMP schemas
- `schemas/tlc/` - Generated Traffic Light Controller schemas
- `examples/validate.rb` - Example validation script
- `Rakefile` - Contains regenerate task
- `.github/workflows/rspec.yaml` - CI pipeline

## Common File Locations

### Schema Files
- Core schemas: `schemas/core/<version>/rsmp.json`
- TLC schemas: `schemas/tlc/<version>/rsmp.json`
- YAML sources: `schemas/tlc/<version>/sxl.yaml`

### Code Files
- Main entry: `lib/rsmp_schema.rb`
- CLI: `lib/rsmp_schema/cli.rb`
- YAML import: `lib/rsmp_schema/convert/import/yaml.rb`
- JSON export: `lib/rsmp_schema/convert/export/json_schema.rb`

### Test Files
- Core tests: `spec/core/`
- TLC tests: `spec/tlc/`
- Helper: `spec/schemer_helper.rb`

## CI Pipeline Validation

The repository uses GitHub Actions with the following requirements:
- Runs on Ubuntu, macOS, and Windows
- Tests Ruby versions 3.1, 3.2, and 3.3
- 5-minute timeout for all tests
- Must pass `bundle exec rspec -f d`

Before committing changes, ensure:
- All tests pass: `bundle exec rspec`
- Ruby syntax is valid for modified files
- Schema regeneration works if you modified YAML files

## Validation Scenarios

After making changes, always test these scenarios:

1. **Basic validation**: Ensure the validation example works correctly
2. **Schema regeneration**: Run `bundle exec rake regenerate` and verify no unexpected changes
3. **Test suite**: Run `bundle exec rspec` and ensure all tests pass
4. **CLI functionality**: Test the convert command with actual files

Example validation workflow:
```bash
# Run tests
bundle exec rspec

# Test CLI conversion  
bundle exec exe/rsmp_schema convert -i schemas/tlc/1.2.1/sxl.yaml -o /tmp/test_output

# Verify output contains expected files
ls -la /tmp/test_output  # Should show rsmp.json, alarms/, commands/, statuses/

# Test validation
sed 's|schema/tlc/1.2.1/rsmp.json|schemas/tlc/1.2.1/rsmp.json|' examples/validate.rb | bundle exec ruby
```

## Dependencies and Versions

See `rsmp_schema.gemspec` for current runtime and development dependencies.

Requires Ruby version as specified in .tool-versions.

## Common Issues and Solutions

**Ruby version or environment issues**:
- Use mise for automatic Ruby management: `mise install`

**Permission errors during bundle install**:
- Use mise which handles permissions automatically

**Missing bundler command**:
- Run `mise install` first, bundler should be available automatically

**JSON Schema validation errors**:
- Check that schema paths use `schemas/` not `schema/` (common typo in examples)
- Ensure you're using `bundle exec ruby` for scripts that require gems

**Test failures**:
- Run `bundle exec rspec` not just `rspec`
- Ensure you've run `bundle install` first
- Check Ruby version compatibility (see .tool-versions)

## Timing Expectations

- **NEVER CANCEL**: Bundle install takes 10-15 seconds normally - wait for completion
- **NEVER CANCEL**: Test suite takes 2 seconds - use 30+ second timeout  
- **NEVER CANCEL**: Schema regeneration takes 0.75 seconds - very fast but allow buffer
- Initial gem setup may take up to 60 seconds total including bundler installation

Set timeouts generously:
- Bundle operations: 60+ seconds
- Test operations: 30+ seconds  
- CLI operations: 30+ seconds