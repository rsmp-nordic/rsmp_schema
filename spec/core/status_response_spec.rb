RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusResponse",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
     "sS" => [
       { "sCI" => "S0003", "n" => "inputstatus", "s" => "100101", "q" => "recent" }
     ]
  }}

  let(:undefined) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusResponse",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
     "sS" => [
       { "sCI" => "S0003", "n" => "inputstatus", "s" => nil, "q" => "undefined" }
     ]
  }}

  it 'vals' do
    attributes = {
      "mType"=>"rSMsg",
      "type"=>"StatusResponse",
      "cId"=>"bad",
      "sTs"=>"2023-07-11T10:46:20.360Z",
      "sS"=>[{"sCI"=>"S0001", "n"=>"signalgroupstatus", "q"=>"undefined", "s"=>nil}],
      "mId"=>"743bab9d-9c39-4ac6-b8fc-0f7113445674", "ntsOId"=>"KK+AG9998=001TC000", "xNId"=>""
    }
    schemas = {tlc: RSMP::Schema.latest_version(:tlc) }
    expect( RSMP::Schema.validate(attributes, schemas) ).to be_nil
  end

  it 'accepts valid message' do
    expect(validate message, 'core').to be_nil
  end

  it 'accepts valid message with q=undefined, s=null from 3.1.3' do
    expect(validate undefined, 'core', '>=3.1.3').to be_nil
  end

  it 'catches missing component id' do
    message.delete 'cId'
    expect(validate message, 'core').to eq( [["", "required", {"missing_keys"=>["cId"]}]] )
  end

  it 'catches bad status code' do
    message['sS'].first['sCI'] = '99'
    expect(validate message, 'core').to eq(
      "3.1.2" => [["/sS/0/sCI", "pattern"]],
      ["3.1.3", "3.1.4", "3.1.5", "3.2"] => [
        ["/sS/0/sCI", "pattern"],
        ["/sS/0/s", "null"],
        ["/sS/0/q", "const"]
      ],
    )
  end

  it 'catches missing sS' do
    message.delete 'sS'
    expect(validate message, 'core').to eq([["", "required", {"missing_keys"=>['sS']}]])
  end

  it 'catches empty sS array' do
    message['sS'].clear
    expect(validate message, 'core').to eq([["/sS", "minItems"]])
  end

  it 'catches bad sS type' do
    message['sS'] = {}
    expect(validate message, 'core').to eq([["/sS", "array"]])
  end

  it 'catches missing status code' do
    message['sS'].first.delete 'sCI'
    expect(validate message, 'core').to eq([["/sS/0", "required", {"missing_keys"=>["sCI"]}]])
  end

  it 'catches bad status code' do
    message['sS'].first['sCI'] = 3
    expect(validate message, 'core').to eq({
      "3.1.2" => [["/sS/0/sCI", "string"]],
      ["3.1.3", "3.1.4", "3.1.5", "3.2"] => [["/sS/0/sCI", "string"], ["/sS/0/s", "null"], ["/sS/0/q", "const"]]
    })


    message['sS'].first['sCI'] = '3'
    expect(validate message, 'core').to eq({
      "3.1.2" => [["/sS/0/sCI", "pattern"]],
      ["3.1.3", "3.1.4", "3.1.5", "3.2"] => [["/sS/0/sCI", "pattern"], ["/sS/0/s", "null"], ["/sS/0/q", "const"]]
    })
  end

  it 'catches missing name' do
    message['sS'].first.delete 'n'
    expect(validate message, 'core').to eq([["/sS/0", "required", {"missing_keys"=>["n"]}]])
  end

  it 'catches bad name' do
    message['sS'].first['n'] = 3
    expect(validate message, 'core').to eq({
      "3.1.2" => [["/sS/0/n", "string"]],
      ["3.1.3", "3.1.4", "3.1.5", "3.2"] => [["/sS/0/n", "string"], ["/sS/0/s", "null"], ["/sS/0/q", "const"]]
    })
  end

  it 'catches n set to null' do
    message['sS'].first['n'] = nil
    expect(validate message, 'core').to eq({
      "3.1.2" => [["/sS/0/n", "string"]],
      ["3.1.3", "3.1.4", "3.1.5", "3.2"] => [["/sS/0/n", "string"], ["/sS/0/s", "null"], ["/sS/0/q", "const"]]
    })
  end

  it 'catches missing value' do
    message['sS'].first.delete 's'
    expect(validate message, 'core').to eq([["/sS/0", "required", {"missing_keys"=>["s"]}]])
  end

  it 'catches missing quality' do
    message['sS'].first.delete 'q'
    expect(validate message, 'core').to eq(
      [["/sS/0", "required", {"missing_keys"=>["q"]}]]
    )
  end

  it 'catches bad quality' do
    message['sS'].first['q'] = 'great'
    expect(validate message, 'core').to eq({
      "3.1.2" => [["/sS/0/q", "enum"]],
      ["3.1.3", "3.1.4", "3.1.5", "3.2"] => [["/sS/0/q", "enum"], ["/sS/0/s", "null"], ["/sS/0/q", "const"]]
    })
  end
end
