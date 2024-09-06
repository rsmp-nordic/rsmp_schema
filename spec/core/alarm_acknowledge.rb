RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "Alarm",
    "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
    "cId" => "AB+84001=860SG001",
    "aCId" => "A0001",
    "xACId" => "",
    "aSp" => "Acknowledge",
    "aTs" => "2009-10-01T11:59:31.571Z"
  }}

  it 'accepts valid alarm issue' do
    expect( validate(message, 'core') ).to be_nil
  end

  it 'accepts aSp case variations only for core < 3.2.0,' do
    valid = message.dup
    valid["aSp"] = 'acknowledge'
    expect( validate(valid, 'core') ).to eq({
      ['3.2.0','3.2.1','3.2.2'] => [["/aSp", "enum"]]
    })
  end

  it 'catches missing component id' do
    message.delete 'cId'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["cId"]}]]
    )
  end

  it 'catches missing alarm code id' do
    message.delete 'aCId'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["aCId"]}]]
    )
  end

  it 'catches bad alarm code id' do
    message['aCId'] = "001"
    expect( validate(message, 'core') ).to eq(
      [["/aCId", "pattern"]]
    )
  end

  it 'catches wrong alarm code id type' do
    message['aCId'] = 123
    expect( validate(message, 'core') ).to eq(
      [["/aCId", "string"]]
    )
  end

  it 'catches missing extended alarm code id' do
    message.delete 'xACId'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["xACId"]}]]
    )
  end

  it 'catches wrong extended alarm code id type' do
    message['xACId'] = 123
    expect( validate(message, 'core') ).to eq(
      [["/xACId", "string"]]
    )
  end

  it 'catches missing timestamp' do
    message.delete 'aTs'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["aTs"]}]]
    )
  end

  it 'catches bad timestamp' do
    message['aTs'] = "yesterday"
    expect( validate(message, 'core') ).to eq(
      [["/aTs", "pattern"]]
    )
  end

  it 'catches wrong timestamp type' do
    message['aTs'] = 123
    expect( validate(message, 'core') ).to eq(
      [["/aTs", "string"]]
    )
  end
end
