RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusUpdate",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
     "sS" => [
       { "sCI" => "S0003", "n" => "inputstatus", "s" => "100101", "q" => "recent" }
     ]
  }}

  it 'accepts valid message' do
    expect(validate message, 'core').to be_nil
  end

  it 'accepts valid status request with unkmown=q, s=null' do
    message['sS'].first['q'] = 'unknown'
    message['sS'].first['s'] = nil
    expect(validate message, 'core').to be_nil
  end

  it 's must be null if q=unknown' do
    message['sS'].first['q'] = 'unknown'
    message['sS'].first['s'] = "1"
    expect(validate message, 'core').to eq(
      [["/sS/0/s", "null"]]
    )
  end

  it 's cannot be null if q!=unknown' do
    message['sS'].first['q'] = 'recent'
    message['sS'].first['s'] = nil
    expect(validate message, 'core').to eq(
       ["3.1.2", "3.1.3", "3.1.4", "3.1.5"] => [["/sS/0/s", "string"]],
       ["3.2.0", "3.2.1", "3.2.2"] => [["/sS/0/s", "type"]],
    )
  end

  it 'catches missing component id' do
    message.delete 'cId'
    expect(validate message, 'core').to eq(
      [["", "required", {"missing_keys"=>["cId"]}]]
    )
  end

  it 'catches bad status code' do
    message['sS'].first['sCI'] = '99'
    expect(validate message, 'core').to eq(
      [["/sS/0/sCI", "pattern"]]
    )
  end

  it 'catches missing sS' do
    message.delete 'sS'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>['sS']}]]
    )
  end

  it 'catches empty sS array' do
    message['sS'].clear
    expect( validate(message, 'core') ).to eq(
      [["/sS", "minItems"]]
    )
  end

  it 'catches bad sS type' do
    message['sS'] = {}
    expect( validate(message, 'core') ).to eq(
      [["/sS", "array"]]
    )
  end

  it 'catches missing status code' do
    message['sS'].first.delete 'sCI'
    expect(validate message, 'core').to eq(
      [["/sS/0", "required", {"missing_keys"=>["sCI"]}]]
    )
  end

  it 'catches bad status code' do
    message['sS'].first['sCI'] = 3
    expect(validate message, 'core').to eq(
      [["/sS/0/sCI", "string"]]
    )

    message['sS'].first['sCI'] = '3'
    expect(validate message, 'core').to eq(
      [["/sS/0/sCI", "pattern"]]
    )
  end

  it 'catches missing name' do
    message['sS'].first.delete 'n'
    expect(validate message, 'core').to eq(
      [["/sS/0", "required", {"missing_keys"=>["n"]}]]
    )
  end

  it 'catches bad name' do
    message['sS'].first['n'] = 3
    expect(validate message, 'core').to eq(
      [["/sS/0/n", "string"]]
    )
  end

  it 'catches n set to null' do
    message['sS'].first['n'] = nil
    expect(validate message, 'core').to eq([["/sS/0/n", "string"]])
  end


  it 'catches missing value' do
    message['sS'].first.delete 's'
    expect(validate message, 'core').to eq(
      [["/sS/0", "required", {"missing_keys"=>["s"]}]]
    )
  end

  it 'catches bad quality' do
    message['sS'].first['q'] = 'great'
    expect(validate message, 'core').to eq(
      [["/sS/0/q", "enum"]]
    )
  end
end
