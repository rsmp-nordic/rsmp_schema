require 'spec_helper'

RSpec.describe "Optional command arguments in YAML conversion" do
  let(:test_yaml_content) { 
    <<~YAML
      ---
      meta:
        name: test
        description: "Test SXL with optional command arguments"
        version: "1.0"

      objects:
        Test Controller:
          description: "Test Controller"
          
          commands:
            M0001:
              description: "Test command with optional arguments"
              command: setValue
              arguments:
                mode:
                  type: string
                  description: "Mode (required)"
                timeout:
                  type: integer
                  optional: true
                  description: "Timeout in seconds (optional)"
                priority:
                  type: integer
                  optional: true
                  description: "Priority level (optional)"
    YAML
  }

  it 'should generate correct JSON schema for commands with optional arguments' do
    # Create test YAML file
    File.write('tmp/test_optional.yaml', test_yaml_content)
    
    # Convert to JSON schema
    system('bundle exec exe/rsmp_schema convert -i tmp/test_optional.yaml -o tmp/test_schema_output')
    
    # Read the generated command schema
    command_schema = JSON.parse(File.read('tmp/test_schema_output/commands/M0001.json'))
    
    # Verify that all arguments are in the enum
    expect(command_schema['allOf'][0]['properties']['n']['enum']).to contain_exactly('mode', 'priority', 'timeout')
    
    # Verify that command operation is setValue
    expect(command_schema['allOf'][0]['properties']['cO']['const']).to eq('setValue')
    
    # Verify that all arguments require 'v' when present (including optional ones)
    conditions = command_schema['allOf'][1]['else']['allOf']
    expect(conditions.length).to eq(3)
    
    # Each condition should require 'v' when that argument name is present
    conditions.each do |condition|
      expect(condition['then']).to have_key('required')
      expect(condition['then']['required']).to include('v')
    end
    
    # Clean up
    FileUtils.rm_f('tmp/test_optional.yaml')
    FileUtils.rm_rf('tmp/test_schema_output')
  end

  it 'should document optional field in YAML format specification' do
    yaml_doc = File.read('sxl_yaml_format.md')
    expect(yaml_doc).to include('optional')
    expect(yaml_doc).to include('optional: true')
  end
end
