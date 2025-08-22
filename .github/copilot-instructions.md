# RSMP Schema Ruby Gem

RSMP Schema is a Ruby gem that provides JSON Schema validation for RSMP (Road Side Message Protocol) messages. The schema covers both the core RSMP specification and SXL (Signal Exchange List) for Traffic Light Controllers.

Always reference these instructions first, and fall back to search or bash commands only when you encounter unexpected information that does not match the info here.

## Environment Setup

Bootstrap, build, and test the repository using mise:

```bash
# Install mise (if not already installed), follow instructions at https://mise.jdx.dev/
curl https://mise.run | sh

# Install the Ruby version specified in .tool-versions
mise install

# Install all dependencies.
# The bundler gem is included by default in the Ruby installation and does not have to be installed first.
bundle install
```

## Running Tests

The test suite includes comprehensive RSpec tests covering:
- Core RSMP message validation
- Traffic Light Controller SXL validation


Run the complete test suite:
```bash
# Test command takes approximately 2 seconds
bundle exec rspec
```

All tests should pass on a clean repository.

## CLI Tool Usage

The gem provides a CLI tool for converting YAML SXL files to JSON Schema:

```bash
# Show available commands
bundle exec exe/rsmp_schema --help

# Convert YAML SXL to JSON Schema
bundle exec exe/rsmp_schema convert -i <input.yaml> -o <output_directory>

# Example: Convert TLC SXL
bundle exec exe/rsmp_schema convert -i schemas/tlc/1.2.1/sxl.yaml -o tmp/sxl_1.2.1_schema
```

## Schema Regeneration

Regenerate all TLC JSON schemas from their YAML sources:

```bash
# Regenerates all schemas in schemas/tlc/*/sxl.yaml
bundle exec rake regenerate
```

**WARNING**: This destructively overwrites all JSON schema files in schemas/tlc/. Core schemas are not affected as they are hand-maintained.

This rake task and the 'convert' CLI command use the same Ruby code to convert YAML to JSON schema files.


## Example code
The file examples/validate.rb shows how to use the gem to validate RSMP messages.

Before committing changes, in addition to checking that all RSpec tests pass, also check that the examples/validate.rb script works and outputs the expected result:

```bash
# Test validation with corrected example script
bundle exec ruby examples/validate.rb
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
- `examples/validate.rb` - Example validation code
- `Rakefile` - Contains regenerate task
- `.github/workflows/rspec.yaml` - CI pipeline

## Common File Locations

### Schema Files
- Core schemas: `schemas/core/<version>/rsmp.json`
- TLC SXL schemas: `schemas/tlc/<version>/rsmp.json`
- TLC SXL YAML sources: `schemas/tlc/<version>/sxl.yaml`

### Code Files
- Main entry: `lib/rsmp_schema.rb`
- CLI: `lib/rsmp_schema/cli.rb`

### Test Files
- Core tests: `spec/core/`
- TLC tests: `spec/tlc/`
- Helper: `spec/schemer_helper.rb`

## CI Pipeline Validation

The repository uses GitHub Actions with the following requirements:
- Runs on Ubuntu, macOS, and Windows
- Tests with different Ruby versions
- 5-minute timeout for all tests
- Must pass `bundle exec rspec -f d`

Before committing changes, ensure:
- Schemas are regenerated if any SXL YAML sources were modified
- All tests pass: `bundle exec rspec`
- Ruby syntax is valid for modified files

## Validation Scenarios

After making changes, always test these scenarios:

1. **Schema regeneration**: Run `bundle exec rake regenerate` and verify no unexpected changes.
2. **Test suite**: Run `bundle exec rspec` and ensure all tests pass.
3. **Example code**: Ensure the examples in examples/ work correctly.
4. **CLI functionality**: Test the convert command with actual files.
5. **No unrelated changes**: No unrelated changes or files should be included in the commit.
 
Example validation workflow:

```bash
# Ensure we're in root of the repo folder
cd /path/to/repo

# Regenerate schema files if SXL YAML sources were modified
# And check that no unexpected changes were introduced
bundle exec rake regenerate
git status -- schemas/

# Run test suite
bundle exec rspec

# Check example code
bundle exec ruby examples/validate.rb

# Check CLI functionality
# And check that output contains expected files
bundle exec exe/rsmp_schema convert -i schemas/tlc/1.2.1/sxl.yaml -o tmp/sxl_1.2.1_schema
ls -la tmp/sxl_1.2.1_schema  # Should show rsmp.json, alarms/, commands/, statuses/

# Check that no unrelated changes or files were introduced
git status
```



## Dependencies and Versions

See `rsmp_schema.gemspec` for current runtime and development dependencies.

Requires the Ruby version specified in .tool-versions.

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
