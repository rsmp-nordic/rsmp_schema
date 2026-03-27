RSpec.describe RSMP::Schema do
  it 'has correct schemas' do
    expect(described_class.schema?(:bad, '3.2.0')).to be(false)
    expect(described_class.schema?(:bad, '1.1.0')).to be(false)

    expect(described_class.schema?(:core, '3.1.1')).to be(false)
    expect(described_class.schema?(:core, '3.1.2')).to be(true)
    expect(described_class.schema?(:core, '3.1.3')).to be(true)
    expect(described_class.schema?(:core, '3.1.4')).to be(true)
    expect(described_class.schema?(:core, '3.1.5')).to be(true)
    expect(described_class.schema?(:core, '3.2.0')).to be(true)
    expect(described_class.schema?(:core, '3.2.1')).to be(true)
    expect(described_class.schema?(:core, '3.2.2')).to be(true)
    expect(described_class.schema?(:core, '3.3')).to be(false)

    expect(described_class.schema?(:tlc, '1.0.6')).to be(false)
    expect(described_class.schema?(:tlc, '1.0.7')).to be(true)
    expect(described_class.schema?(:tlc, '1.0.8')).to be(true)
    expect(described_class.schema?(:tlc, '1.0.9')).to be(true)
    expect(described_class.schema?(:tlc, '1.0.10')).to be(true)
    expect(described_class.schema?(:tlc, '1.0.11')).to be(false)
    expect(described_class.schema?(:tlc, '1.0.12')).to be(false)
    expect(described_class.schema?(:tlc, '1.0.13')).to be(true)
    expect(described_class.schema?(:tlc, '1.0.14')).to be(true)
    expect(described_class.schema?(:tlc, '1.0.15')).to be(true)
    expect(described_class.schema?(:tlc, '1.1.0')).to be(true)
    expect(described_class.schema?(:tlc, '1.2.0')).to be(true)
    expect(described_class.schema?(:tlc, '1.2.1')).to be(true)
    expect(described_class.schema?(:tlc, '1.2.2')).to be(false)
  end

  it 'provides schema versions' do
    expect(described_class.core_versions).to eq(['3.1.2', '3.1.3', '3.1.4', '3.1.5', '3.2.0', '3.2.1', '3.2.2'])
    expect(described_class.earliest_core_version).to eq('3.1.2')
    expect(described_class.latest_core_version).to eq('3.2.2')

    expect(described_class.versions(:tlc)).to eq(['1.0.7', '1.0.8', '1.0.9', '1.0.10', '1.0.13', '1.0.14', '1.0.15',
                                                  '1.1.0', '1.2.0', '1.2.1'])
    expect(described_class.earliest_version(:tlc)).to eq('1.0.7')
    expect(described_class.latest_version(:tlc)).to eq('1.2.1')
  end

  it 'parses versions strings strictly' do
    expect(described_class.schema?(:core, '3.2.0.extra.9.8.7')).to be(false)
    expect(described_class.schema?(:tlc, '1.1.extra.9.8.7')).to be(false)
  end

  it 'parses versions strings leniently' do
    expect(described_class.schema?(:core, '3.2.0.extra.9.8.7', lenient: true)).to be(true)
    expect(described_class.schema?(:tlc, '1.1.0.extra.9.8.7', lenient: true)).to be(true)
  end

  it 'finds schema without patch version when parsning leniently' do
    expect(described_class.schema?(:core, '3.2', lenient: true)).to be(true)
    expect(described_class.schema?(:core, '3.2', lenient: false)).to be(false)
  end

  it 'raises when schema not found' do
    expect do
      described_class.find_schema!(:bad, '3.2.0')
    end.to raise_error(RSMP::Schema::UnknownSchemaTypeError)

    expect do
      described_class.find_schema!(:core, '0.0.0')
    end.to raise_error(RSMP::Schema::UnknownSchemaVersionError)
  end

  it 'returns nil when schema not found' do
    expect(described_class.find_schema(:bad, '3.2.0')).to be_nil
    expect(described_class.find_schema(:bad, '3.2.0')).to be_nil
  end

  it 'finds schemas or return nil' do
    expect(described_class.find_schemas(:core)).to be_a(Hash)
    expect(described_class.find_schemas(:bad)).to be_nil
  end

  it 'raise exception when trying to validate against non-existing version' do
    message = {
      'mType' => 'rSMsg',
      'type' => 'AggregatedStatusRequest',
      'mId' => 'E68A0010-C336-41ac-BD58-5C80A72C7092',
      'cId' => 'AB+84001=860SG001'
    }
    expect do
      described_class.validate(message, core: '0.0.1')
    end.to raise_error(RSMP::Schema::UnknownSchemaVersionError)
  end

  it 'can load and remove custom schema' do
    expect(described_class.schema_types).to eq(%i[core tlc])
    type = :custom
    path = File.expand_path(File.join(__dir__, '..', '..', 'schemas', 'tlc'))
    described_class.load_schema_type type, path
    expect(described_class.schema_types).to eq(%i[core tlc custom])
    expect(described_class.versions(type)).to eq(['1.0.7', '1.0.8', '1.0.9', '1.0.10', '1.0.13', '1.0.14', '1.0.15',
                                                  '1.1.0', '1.2.0', '1.2.1'])

    expect do
      described_class.load_schema_type type, path # should complain that type is already loaded
    end.to raise_error(RuntimeError)

    expect do
      described_class.load_schema_type type, path, force: true # should be able to force
    end.not_to raise_error

    described_class.remove_schema_type type                      # remove custom schema
    expect(described_class.schema_types).to eq(%i[core tlc])
  ensure
    described_class.remove_schema_type type                      # cleanup
  end

  describe '#sanitize_version' do
    it 'returns correct version string' do
      expect(described_class.sanitize_version('1.2.1')).to eq('1.2.1')
    end
  end
end
