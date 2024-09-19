RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "Alarm",
    "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
    "cId" => "AB+84001=860SG001",
    "aCId" => "A0001",
    "xACId" => "",
    "aSp" => "Suspend",
    "aTs" => "2009-10-01T11:59:31.571Z"
  }}

  it 'accepts valid alarm suspend' do
    expect( validate(message, 'core') ).to be_nil
  end

  it 'rejects lowercase suspend/resume from core 3.1.4' do
    message['aSp'] = "suspend"
    expect( validate(message, 'core') ).to eq(
      ["3.1.4", "3.1.5", "3.2.0", "3.2.1", "3.2.2"] => [["/aSp", "enum"]]
    )
  end

end