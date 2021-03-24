RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "Alarm",
    "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
    "cId" => "AB+84001=860SG001",
    "aCId" => "A0001",
    "aSp" => "Request"
  }}

  it 'accepts valid alarm request' do
    expect( validate(message) ).to be_nil
  end


  it 'catches missing component id' do
    invalid = message.dup
    invalid.delete 'cId'
    expect( validate(invalid) ).to eq([
      ["", "required", {"missing_keys"=>["cId"]}]
    ])
  end

  it 'catches missing alarm code id' do
    invalid = message.dup
    invalid.delete 'aCId'
    expect( validate(invalid) ).to eq([
      ["", "required", {"missing_keys"=>["aCId"]}]
    ])
  end

  it 'catches bad alarm code id' do
    invalid = message.dup
    invalid['aCId'] = "001"
    expect( validate(invalid) ).to eq([
      ["/aCId", "pattern"]
    ])
  end

  it 'catches wrong alarm code id type' do
    invalid = message.dup
    invalid['aCId'] = 123
    expect( validate(invalid) ).to eq([
      ["/aCId", "string"]
    ])
  end

  it 'catches missing extended alarm code id' do
    invalid = message.dup
    invalid.delete 'xACId'
    expect( validate(invalid) ).to eq([
      ["", "required", {"missing_keys"=>["xACId"]}]
    ])
  end

  it 'catches wrong extended alarm code id type' do
    invalid = message.dup
    invalid['xACId'] = 123
    expect( validate(invalid) ).to eq([
      ["/xACId", "string"]
    ])
  end

  it 'catches extraneous alarm code id' do
    invalid = message.dup
    invalid['aS'] = 'Active'
    expect( validate(invalid) ).to eq([
      ["", "required", {"missing_keys"=>["aS"]}]
    ])
  end

end
