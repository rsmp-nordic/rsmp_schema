RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message_3_1_2) {{
    "mType" => "rSMsg",
    "type" => "AggregatedStatus",
    "mId" => "be12ab9a-800c-4c19-8c50-adf832f22420",
    "cId" => "O+14439=481WA001",
    "aSTS" => "2015-06-08T08:05:06.584Z",
    "fP" => nil,
    "fS" => nil,
    "se" => [
      'true','false','false','false','false','false','false','false'
    ]
  }}

  let(:message) {{
    "mType" => "rSMsg",
    "type" => "AggregatedStatus",
    "mId" => "be12ab9a-800c-4c19-8c50-adf832f22420",
    "cId" => "O+14439=481WA001",
    "aSTS" => "2015-06-08T08:05:06.584Z",
    "fP" => nil,
    "fS" => nil,
    "se" => [
      true,false,false,false,false,false,false,false
    ]
  }}

  it 'accepts valid message' do
    expect( validate(message_3_1_2, 'core', '<=3.1.2') ).to be_nil
    expect( validate(message, 'core', '>=3.1.3') ).to be_nil
  end

  it 'catches missing mId' do
    message_3_1_2.delete 'mId'
    expect( validate(message_3_1_2, 'core', '<=3.1.2') ).to eq(
      [["", "required", {"missing_keys"=>["mId"]}]]
    )

    message.delete 'mId'
    expect( validate(message, 'core', '>=3.1.3') ).to eq(
      [["", "required", {"missing_keys"=>["mId"]}]]
    )
  end

  it 'catches missing aSTS' do
    message_3_1_2.delete 'aSTS'
    expect( validate(message_3_1_2, 'core', '<=3.1.2') ).to eq(
      [["", "required", {"missing_keys"=>["aSTS"]}]]
    )

    message.delete 'aSTS'
    expect( validate(message, 'core', '>=3.1.3') ).to eq(
      [["", "required", {"missing_keys"=>["aSTS"]}]]
    )
  end

  it 'catches bad aSTS' do
    message_3_1_2['aSTS'] = "2015-06-08T08:05:06.5843Z"
    expect( validate(message_3_1_2, 'core', '<=3.1.2') ).to eq(
      [["/aSTS", "pattern"]]
    )

    message['aSTS'] = "2015-06-08T08:05:06.5843Z"
    expect( validate(message, 'core', '>=3.1.3') ).to eq(
      [["/aSTS", "pattern"]]
    )
  end

  it 'catches missing se' do
    message_3_1_2.delete 'se'
    expect( validate(message_3_1_2, 'core', '<=3.1.2') ).to eq(
      [["", "required", {"missing_keys"=>["se"]}]]
    )

    message.delete 'se'
    expect( validate(message, 'core', '>=3.1.3') ).to eq(
      [["", "required", {"missing_keys"=>["se"]}]]
    )
  end

  it 'catches bad se' do
    # 3.1.2
    message_3_1_2['se'] = 123
    expect( validate(message_3_1_2, 'core', '<=3.1.2') ).to eq(
      [["/se", "array"]]
    )

    message_3_1_2['se'] = ['true','false','false','false','false','false','false']
    expect( validate(message_3_1_2, 'core', '<=3.1.2') ).to eq(
      [["/se", "minItems"]]
    )

    message_3_1_2['se'] = ['true','false','false','false','false','false','false','false','true']
    expect( validate(message_3_1_2, 'core', '<=3.1.2') ).to eq(
      [["/se", "maxItems"]]
    )

    message_3_1_2['se'] = ['true','false','false',1,nil,true,'false','false']
    expect( validate(message_3_1_2, 'core', '<=3.1.2') ).to eq(
      [["/se/3", "string"],
      ["/se/4", "string"],
      ["/se/5", "string"]]
    )

    # 3.1.3 or later
    message['se'] = 123
    expect( validate(message, 'core', '>=3.1.3') ).to eq(
      [["/se", "array"]]
    )

    message['se'] = [true,false,false,false,false,false,false]
    expect( validate(message, 'core', '>=3.1.3') ).to eq(
      [["/se", "minItems"]]
    )

    message['se'] = [true,false,false,false,false,false,false,true,true]
    expect( validate(message, 'core', '>=3.1.3') ).to eq(
      [["/se", "maxItems"]]
    )

    message['se'] = [false,false,false,1,nil,"",false,false]
    expect( validate(message, 'core', '>=3.1.3') ).to eq(
      [["/se/3", "boolean"],
      ["/se/4", "boolean"],
      ["/se/5", "boolean"]]
    )
  end

end