RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message_3_1_1) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusResponse",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
     "sS" => [
       { "sCI" => "S0003", "n" => "inputstatus", "s" => "100101", "ageState" => "recent" }
     ]
  }}

  let(:message_3_1_3) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusResponse",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
     "sS" => [
       { "sCI" => "S0003", "n" => "inputstatus", "s" => "100101", "q" => "recent" }
     ]
  }}

  def make_variations
    {
      '3.1.1' => message_3_1_1,
      '3.1.2' => message_3_1_1,
      '3.1.3' => message_3_1_3,
      '3.1.4' => message_3_1_3,
      '3.1.5' => message_3_1_3,
      '3.2'   => message_3_1_3
    }
  end

  def validate_core
    validate_variations(make_variations, 'core')
  end

  it 'accepts ageState in message_3_1_1 versions, q in newer' do
    expect(validate_core).to be_nil
  end

  it 'rejects q in message_3_1_1 version, ageState in newer' do
    expect( validate(message_3_1_3, 'core', '<3.1.3') ).to eq(
      [["/sS/0", "required", {"missing_keys"=>["ageState"]}], ["/sS/0/q", "schema"]]
    )

    expect( validate(message_3_1_1, 'core', '>=3.1.3') ).to eq(
      [["/sS/0", "required", {"missing_keys"=>["q"]}],["/sS/0/ageState", "schema"]]
    )
  end

  it 'catches missing component id' do
    message_3_1_1.delete 'cId'
    message_3_1_3.delete 'cId'
    expect(validate_core).to eq( [["", "required", {"missing_keys"=>["cId"]}]] )
  end

  it 'catches bad status code' do
    message_3_1_3['sS'].first['sCI'] = '99'
    message_3_1_1['sS'].first['sCI'] = '99'
    expect(validate_core).to eq([["/sS/0/sCI", "pattern"]])
  end

  it 'catches missing sS' do
    message_3_1_3.delete 'sS'
    message_3_1_1.delete 'sS'
    expect(validate_core).to eq([["", "required", {"missing_keys"=>['sS']}]])
  end

  it 'catches empty sS array' do
    message_3_1_3['sS'].clear
    expect( validate(message_3_1_3, 'core') ).to eq([["/sS", "minItems"]])
  end

  it 'catches bad sS type' do
    message_3_1_3['sS'] = {}
    expect( validate(message_3_1_3, 'core') ).to eq([["/sS", "array"]])
  end

  it 'catches missing status code' do
    message_3_1_1['sS'].first.delete 'sCI'
    message_3_1_3['sS'].first.delete 'sCI'
    expect(validate_core).to eq([["/sS/0", "required", {"missing_keys"=>["sCI"]}]])
  end

  it 'catches bad status code' do
    message_3_1_1['sS'].first['sCI'] = 3
    message_3_1_3['sS'].first['sCI'] = 3
    expect(validate_core).to eq([["/sS/0/sCI", "string"]])

    message_3_1_3['sS'].first['sCI'] = '3'
    message_3_1_1['sS'].first['sCI'] = '3'
    expect(validate_core).to eq([["/sS/0/sCI", "pattern"]])
  end

  it 'catches missing name' do
    message_3_1_1['sS'].first.delete 'n'
    message_3_1_3['sS'].first.delete 'n'
    expect(validate_core).to eq([["/sS/0", "required", {"missing_keys"=>["n"]}]])
  end

  it 'catches bad name' do
    message_3_1_1['sS'].first['n'] = 3
    message_3_1_3['sS'].first['n'] = 3
    expect(validate_core).to eq([["/sS/0/n", "string"]])
  end

  it 'catches missing value' do
    message_3_1_1['sS'].first.delete 's'
    message_3_1_3['sS'].first.delete 's'
    expect(validate_core).to eq([["/sS/0", "required", {"missing_keys"=>["s"]}]])
  end

  it 'catches missing quality' do
    message_3_1_1['sS'].first.delete 'ageState'
    message_3_1_3['sS'].first.delete 'q'
    expect( validate(message_3_1_1, 'core', ['3.1.1','3.1.2']) ).to eq(
      [["/sS/0", "required", {"missing_keys"=>["ageState"]}]]
    )
    expect( validate(message_3_1_3, 'core', ['3.1.3','3.1.4','3.1.5','3.2']) ).to eq(
      [["/sS/0", "required", {"missing_keys"=>["q"]}]]
    )
  end

  it 'catches bad quality' do
    message_3_1_1['sS'].first['ageState'] = 'great'
    message_3_1_3['sS'].first['q'] = 'great'
    expect( validate(message_3_1_1, 'core', ['3.1.1','3.1.2']) ).to eq(
      [["/sS/0/ageState", "enum"]]
    )
    expect( validate(message_3_1_3, 'core', ['3.1.3','3.1.4','3.1.5','3.2']) ).to eq(
      [["/sS/0/q", "enum"]]
    )
  end
end
