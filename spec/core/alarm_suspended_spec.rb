RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "Alarm",
    "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
    "cId" => "AB+84001=860SG001",
    "aCId" => "A0001",
    "xACId" => "",
    "aSp" => "Suspend",
    "ack" => "notAcknowledged",
    "aS" => "Active",
    "sS" => "Suspended",
    "aTs" => "2009-10-01T11:59:31.571Z",
    "cat" => "D",
    "pri" => "2",
    "rvs" => [
      {
        "n" => "color",
        "v" => "red"
      }
    ]
  }}

  it 'accepts valid alarm issue' do
    expect( validate(message, 'core') ).to be_nil
  end

  # Before 3.2.0 these variations are allowed: Active, active, inActive, inactive, InActive.
  # From 3.2.0, only these two are allowed: Active, inActive
  # So from 3.2.0 these are not allowed anymore: active, inactive, InActive.
  # We should therefore get validation errors from 3.2.0 for these three variations.
  it 'accepts aS case variations only for core < 3.2.0' do
    valid = message.dup
    # from 3.2.0, "inActive" and "Active" are the only allowed enums
    [ "active","inactive", "InActive" ].each do |status|
      valid["aS"] = status
      expect( validate(valid, 'core') ).to eq({
        ['3.2.0','3.2.1','3.2.2','3.3.0'] => [["/aS", "enum"]]
      })
    end
  end
end