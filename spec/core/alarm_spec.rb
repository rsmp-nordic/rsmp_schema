RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "Alarm",
    "mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
    "cId" => "AB+84001=860SG001",
    "aCId" => "A0001",
    "xACId" => "Serious lamp error",
    "aSp" => "Issue",
    "ack" => "notAcknowledged",
    "aS" => "Active",
    "sS" => "notSuspended",
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

  it 'accepts case variations' do
    valid = message.dup
    valid["aSp"] = 'issue'
    expect( validate(valid, 'core') ).to eq({
      '3.2' => [["/aSp", "enum"]]
    })

    valid = message.dup
    valid["aS"] = 'active'
    expect( validate(valid, 'core') ).to be_nil
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

  it 'catches missing state' do
    message.delete 'aSp'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["aSp"]}]]
    )
  end

  it 'catches bad state' do
    message['aSp'] = "Bad"
    expect( validate(message, 'core') ).to eq(
      [["/aSp", "enum"]]
    )
  end

  it 'catches wrong state type' do
    message['aSp'] = 123
    expect( validate(message, 'core') ).to eq(
      [["/aSp", "enum"],
      ["/aSp", "string"]]
    )
  end

  it 'catches missing alarm code id' do
    message.delete 'aS'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["aS"]}]]
    )
  end

  it 'catches bad alarm code id' do
    message['aS'] = "Bad"
    expect( validate(message, 'core') ).to eq(
      [["/aS", "enum"]]
    )
  end

  it 'catches wrong alarm code id type' do
    message['aS'] = 123
    expect( validate(message, 'core') ).to eq(
      [["/aS", "enum"],
      ["/aS", "string"]]
    )
  end

  it 'catches missing alarm code id' do
    message.delete 'sS'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["sS"]}]]
    )
  end

  it 'catches bad alarm code id' do
    message['sS'] = "Bad"
    expect( validate(message, 'core') ).to eq(
      [["/sS", "enum"]]
    )
  end

  it 'catches wrong alarm code id type' do
    message['sS'] = 123
    expect( validate(message, 'core') ).to eq(
      [["/sS", "enum"],
      ["/sS", "string"]]
    )
  end

  it 'catches missing alarm code id' do
    message.delete 'ack'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["ack"]}]]
    )
  end

  it 'catches bad alarm code id' do
    message['ack'] = "Bad"
    expect( validate(message, 'core') ).to eq(
      [["/ack", "enum"]]
    )
  end

  it 'catches wrong alarm code id type' do
    message['ack'] = 123
    expect( validate(message, 'core') ).to eq(
      [["/ack", "enum"],
      ["/ack", "string"]]
    )
  end

  it 'catches missing category' do
    message.delete 'cat'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["cat"]}]]
    )
  end

  it 'catches bad category' do
    message['cat'] = "A"
    expect( validate(message, 'core') ).to eq(
      [["/cat", "enum"]]
    )
  end

  it 'catches wrong category' do
    message['cat'] = 123
    expect( validate(message, 'core') ).to eq(
      [["/cat", "enum"],
      ["/cat", "string"]]
    )
  end

  it 'catches missing priority' do
    message.delete 'pri'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["pri"]}]]
    )
  end

  it 'catches bad priority' do
    message['pri'] = "4"
    expect( validate(message, 'core') ).to eq(
      [["/pri", "enum"]]
    )
  end

  it 'catches wrong priority' do
    message['pri'] = 1
    expect( validate(message, 'core') ).to eq(
      [["/pri", "enum"],
      ["/pri", "string"]]
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

  it 'catches missing rvs' do
    message.delete 'rvs'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["rvs"]}]]
    )
  end

  it 'catches bad rvs type' do
    message["rvs"] = {}
    expect( validate(message, 'core') ).to eq(
      [["/rvs", "array"]]
    )
  end

  it 'catches missing alarm name' do
    message["rvs"].first.delete 'n'
    expect( validate(message, 'core') ).to eq(
      [["/rvs/0", "required", {"missing_keys"=>["n"]}]]
    )
  end

  it 'catches bad alarm name' do
    message["rvs"].first['n'] = 3
    expect( validate(message, 'core') ).to eq(
      [["/rvs/0/n", "string"]]
    )
  end

  it 'catches missing alarm value' do
    message["rvs"].first.delete 'v'
    expect( validate(message, 'core') ).to eq(
      [["/rvs/0", "required", {"missing_keys"=>["v"]}]]
    )
  end

  it 'catches bad alarm value' do
    message["rvs"].first['v'] = 3
    expect( validate(message, 'core') ).to eq(
      [["/rvs/0/v", "string"]]
    )
  end

  it 'accepts alarm with wrong aSp casing before 3.2' do
    s = %/{"mType":"rSMsg","type":"Alarm","mId":"5a453f52-48d1-4373-8ae1-bb895320e8ad","ntsOId":"KK+AG9998=001TC000","xNId":"","cId":"KK+AG9998=001SG009","aCId":"A0201","xACId":"C_LAMP_OFF_RED (8230, 9, 1) : Signal Group #9","xNACId":"","aSp":"issue","ack":"notAcknowledged","aS":"active","sS":"notSuspended","aTs":"2022-09-02T12:21:24.000Z","cat":"D","pri":"2","rvs":[{"n":"color","v":"red"}]}/
    json = JSON.parse s
    expect( validate(json, 'core', '<3.2') ).to be_nil
    expect( validate(json, 'core', '>=3.2') ).to eq([["/aSp", "enum"]])
  end
end
