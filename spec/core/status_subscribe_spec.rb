RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message_3_1_1) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusSubscribe",
    "cId" => "O+14439=481WA001",
     "sS" => [
       { "sCI" => "S0003", "n" => "inputstatus", "uRt" => "0" }
     ]
  }}
  let(:message_3_1_5) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusSubscribe",
    "cId" => "O+14439=481WA001",
     "sS" => [
       { "sCI" => "S0003", "n" => "inputstatus", "uRt" => "0", "sOc" => "True" }
     ]
  }}

  def make_variations
    {
      '3.1.1' => message_3_1_1,
      '3.1.2' => message_3_1_1,
      '3.1.3' => message_3_1_1,
      '3.1.4' => message_3_1_1,
      '3.1.5' => message_3_1_5
    }
  end

  def validate_core
    validate_variations(make_variations, 'core')
  end

  it 'accepts valid status subscription' do
    expect(validate_core).to be_nil
  end

  it 'catches missing component id' do
    message_3_1_1.delete 'cId'
    message_3_1_5.delete 'cId'
    expect(validate_core).to eq(
      [["", "required", {"missing_keys"=>["cId"]}]]
    )
  end

  it 'catches bad status code' do
    message_3_1_1['sS'].first['sCI'] = '99'
    message_3_1_5['sS'].first['sCI'] = '99'
    expect(validate_core).to eq(
      [["/sS/0/sCI", "pattern"]]
    )
  end

  it 'catches missing sS' do
    message_3_1_1.delete 'sS'
    message_3_1_5.delete 'sS'
    expect(validate_core).to eq(
      [["", "required", {"missing_keys"=>['sS']}]]
    )
  end

  it 'catches empty sS array' do
    message_3_1_1['sS'].clear
    message_3_1_5['sS'].clear
    expect(validate_core).to eq(
      [["/sS", "minItems"]]
    )
  end

  it 'catches bad sS type' do
    message_3_1_1['sS'] = {}
    message_3_1_5['sS'] = {}
    expect(validate_core).to eq(
      [["/sS", "array"]]
    )
  end

  it 'catches missing status code' do
    message_3_1_1['sS'].first.delete 'sCI'
    message_3_1_5['sS'].first.delete 'sCI'
    expect(validate_core).to eq(
      [["/sS/0", "required", {"missing_keys"=>["sCI"]}]]
    )
  end

  it 'catches bad status code' do
    message_3_1_1['sS'].first['sCI'] = 3
    message_3_1_5['sS'].first['sCI'] = 3
    expect(validate_core).to eq(
      [["/sS/0/sCI", "string"]]
    )

    message_3_1_1['sS'].first['sCI'] = '3'
    message_3_1_5['sS'].first['sCI'] = '3'
    expect(validate_core).to eq(
      [["/sS/0/sCI", "pattern"]]
    )
  end

  it 'catches missing name' do
    message_3_1_1['sS'].first.delete 'n'
    message_3_1_5['sS'].first.delete 'n'
    expect(validate_core).to eq(
      [["/sS/0", "required", {"missing_keys"=>["n"]}]]
    )
  end

  it 'catches bad name' do
    message_3_1_1['sS'].first['n'] = 3
    message_3_1_5['sS'].first['n'] = 3
    expect(validate_core).to eq(
      [["/sS/0/n", "string"]]
    )
  end

  it 'catches missing uRt' do
    message_3_1_1['sS'].first.delete 'uRt'
    message_3_1_5['sS'].first.delete 'uRt'
    expect(validate_core).to eq(
      [["/sS/0", "required", {"missing_keys"=>["uRt"]}]]
    )
  end

  it 'catches bad uRt' do
    message_3_1_1['sS'].first['uRt'] = 3
    message_3_1_5['sS'].first['uRt'] = 3
    expect(validate_core).to eq(
      [["/sS/0/uRt", "string"]]
    )

    message_3_1_1['sS'].first['uRt'] = "fast"
    message_3_1_5['sS'].first['uRt'] = "fast"
    expect(validate_core).to eq(
      [["/sS/0/uRt", "pattern"]]
    )
  end

  it 'catches missing sOc' do
    message_3_1_5['sS'].first.delete 'sOc'
    expect(validate_core).to eq({
      '3.1.5' => [["/sS/0", "required", {"missing_keys"=>["sOc"]}]]
    })
  end

  it 'catches extra attributes' do
    message_3_1_1['sS'].first['bad'] = "Foo"
    message_3_1_5['sS'].first['bad'] = "Foo"
    expect(validate_core).to eq(
      [["/sS/0/bad", "schema"]]
    )
  end

end
