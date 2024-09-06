RSpec.describe RSMP::Schema do
  it 'has correct schemas' do
    expect(RSMP::Schema.has_schema?(:bad,'3.2.0')).to be(false)
    expect(RSMP::Schema.has_schema?(:bad,'1.1.0')).to be(false)

    expect(RSMP::Schema.has_schema?(:core,'3.1.1')).to be(false)
    expect(RSMP::Schema.has_schema?(:core,'3.1.2')).to be(true)
    expect(RSMP::Schema.has_schema?(:core,'3.1.3')).to be(true)
    expect(RSMP::Schema.has_schema?(:core,'3.1.4')).to be(true)
    expect(RSMP::Schema.has_schema?(:core,'3.1.5')).to be(true)
    expect(RSMP::Schema.has_schema?(:core,'3.2.0')).to be(true)
    expect(RSMP::Schema.has_schema?(:core,'3.2.1')).to be(true)
    expect(RSMP::Schema.has_schema?(:core,'3.2.2')).to be(true)
    expect(RSMP::Schema.has_schema?(:core,'3.3')).to be(false)

    expect(RSMP::Schema.has_schema?(:tlc,'1.0.6')).to be(false)
    expect(RSMP::Schema.has_schema?(:tlc,'1.0.7')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.0.8')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.0.9')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.0.10')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.0.11')).to be(false)
    expect(RSMP::Schema.has_schema?(:tlc,'1.0.12')).to be(false)
    expect(RSMP::Schema.has_schema?(:tlc,'1.0.13')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.0.14')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.0.15')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.1.0')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.2.0')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.2.1')).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.2.2')).to be(false)
  end

  it 'provides schema versions' do
    expect(RSMP::Schema.core_versions).to eq(["3.1.2", "3.1.3", "3.1.4", "3.1.5", "3.2.0", "3.2.1", "3.2.2"])
    expect(RSMP::Schema.earliest_core_version).to eq("3.1.2")
    expect(RSMP::Schema.latest_core_version).to eq("3.2.2")

    expect(RSMP::Schema.versions(:tlc)).to eq(["1.0.7", "1.0.8", "1.0.9", "1.0.10", "1.0.13", "1.0.14", "1.0.15", "1.1.0", "1.2.0", "1.2.1"])
    expect(RSMP::Schema.earliest_version(:tlc)).to eq("1.0.7")
    expect(RSMP::Schema.latest_version(:tlc)).to eq("1.2.1")

  end

  it 'parses versions strings strictly' do
    expect(RSMP::Schema.has_schema?(:core,'3.2.0.extra.9.8.7')).to be(false)
    expect(RSMP::Schema.has_schema?(:tlc,'1.1.extra.9.8.7')).to be(false)
  end

  it 'parses versions strings leniently' do
    expect(RSMP::Schema.has_schema?(:core,'3.2.0.extra.9.8.7', lenient: true)).to be(true)
    expect(RSMP::Schema.has_schema?(:tlc,'1.1.0.extra.9.8.7', lenient: true)).to be(true)
  end

  it 'finds schema without patch version when parsning leniently' do
    expect(RSMP::Schema.has_schema?(:core,'3.2', lenient: true)).to be(true)
    expect(RSMP::Schema.has_schema?(:core,'3.2', lenient: false)).to be(false)
  end

  it 'raises when schema not found' do
    expect {
      RSMP::Schema.find_schema!(:bad,'3.2.0')
    }.to raise_error(RSMP::Schema::UnknownSchemaTypeError)

    expect {
      RSMP::Schema.find_schema!(:core,'0.0.0')
    }.to raise_error(RSMP::Schema::UnknownSchemaVersionError)
  end

  it 'returns nil when schema not found' do
    expect(RSMP::Schema.find_schema(:bad,'3.2.0')).to be_nil
    expect(RSMP::Schema.find_schema(:bad,'3.2.0')).to be_nil
  end

  it 'finds schemas or return nil' do
    expect(RSMP::Schema.find_schemas(:core)).to be_a(Hash)
    expect(RSMP::Schema.find_schemas(:bad)).to be_nil
  end

  it "raise exception when trying to validate against non-existing version" do
    message = {
      "mType" => "rSMsg",
      "type" => "AggregatedStatusRequest",
      "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
      "cId" => "AB+84001=860SG001"
    }
    expect {
      RSMP::Schema.validate(message, core: '0.0.1')
    }.to raise_error(RSMP::Schema::UnknownSchemaVersionError)
  end

  it "can load and remove custom schema" do
    expect(RSMP::Schema.schema_types).to eq([:core,:tlc])
    type = :custom
    path = File.expand_path( File.join(__dir__,'..','schemas','tlc') )
    RSMP::Schema.load_schema_type type, path
    expect(RSMP::Schema.schema_types).to eq([:core,:tlc,:custom])
    expect(RSMP::Schema.versions(type)).to eq(["1.0.7", "1.0.8", "1.0.9", "1.0.10", "1.0.13", "1.0.14", "1.0.15", "1.1.0", "1.2.0", "1.2.1"])

    expect {
      RSMP::Schema.load_schema_type type, path                # should complain that type is already loaded
    }.to raise_error(RuntimeError)

    expect {
      RSMP::Schema.load_schema_type type, path, force:true    # should be able to force
    }.not_to raise_error

    RSMP::Schema.remove_schema_type type                      # remove custom schema
    expect(RSMP::Schema.schema_types).to eq([:core,:tlc])
  ensure
    RSMP::Schema.remove_schema_type type                      # cleanup
  end
end
