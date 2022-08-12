RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:older) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "StatusUpdate",
	  "cId" => "O+14439=481WA001",
	  "sTs" => "2015-06-08T09:15:18.266Z",
     "sS" => [
	     { "sCI" => "S0003", "n" => "inputstatus", "s" => "100101", "ageState" => "recent" }
	   ]
	}}

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

  def make_variations
  	{
      '3.1.1' => older,
      '3.1.2' => older,
      '3.1.3' => message,
      '3.1.4' => message,
      '3.1.5' => message
    }
  end

  it 'accepts ageState in older versions, q in newer' do
    expect( validate_variations(make_variations, 'core', '3.1.1') ).to be_nil
  end

  it 'rejects q in older version, ageState in newer' do
    expect( validate(message, 'core', ['3.1.1','3.1.2']) ).to eq(
      [["/sS/0", "required", {"missing_keys"=>["ageState"]}], ["/sS/0/q", "schema"]]
     )

    expect( validate(older, 'core', ['3.1.3','3.1.4','3.1.5']) ).to eq(
     [["/sS/0", "required", {"missing_keys"=>["q"]}], ["/sS/0/ageState", "schema"]]
     )
  end

	it 'accepts valid status request' do
	  expect( validate_variations(make_variations, 'core', :all) ).to be_nil
  end

  it 'catches missing component id' do
		older.delete 'cId'
		message.delete 'cId'
	  expect( validate_variations(make_variations, 'core', :all) ).to eq(
	  	[["", "required", {"missing_keys"=>["cId"]}]]
	  )
  end

  it 'catches bad status code' do
		older['sS'].first['sCI'] = '99'
		message['sS'].first['sCI'] = '99'
	  expect( validate_variations(make_variations, 'core', :all) ).to eq(
	  	[["/sS/0/sCI", "pattern"]]
	  )
  end

  it 'catches missing sS' do
		message.delete 'sS'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["", "required", {"missing_keys"=>['sS']}]]
	  )
  end

  it 'catches empty sS array' do
		message['sS'].clear
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/sS", "minItems"]]
	  )
  end

  it 'catches bad sS type' do
		message['sS'] = {}
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/sS", "array"]]
	  )
  end

  it 'catches missing status code' do
		older['sS'].first.delete 'sCI'
		message['sS'].first.delete 'sCI'
	  expect( validate_variations(make_variations, 'core', :all) ).to eq(
	  	[["/sS/0", "required", {"missing_keys"=>["sCI"]}]]
	  )
  end

  it 'catches bad status code' do
		older['sS'].first['sCI'] = 3
		message['sS'].first['sCI'] = 3
	  expect( validate_variations(make_variations, 'core', :all) ).to eq(
	  	[["/sS/0/sCI", "string"]]
	  )

		older['sS'].first['sCI'] = '3'
		message['sS'].first['sCI'] = '3'
	  expect( validate_variations(make_variations, 'core', :all) ).to eq(
	  	[["/sS/0/sCI", "pattern"]]
	  )
  end

  it 'catches missing name' do
		older['sS'].first.delete 'n'
		message['sS'].first.delete 'n'
	  expect( validate_variations(make_variations, 'core', :all) ).to eq(
	  	[["/sS/0", "required", {"missing_keys"=>["n"]}]]
	  )
  end

  it 'catches bad name' do
		older['sS'].first['n'] = 3
		message['sS'].first['n'] = 3
	  expect( validate_variations(make_variations, 'core', :all) ).to eq(
	  	[["/sS/0/n", "string"]]
	  )
  end

  it 'catches missing value' do
		older['sS'].first.delete 's'
		message['sS'].first.delete 's'
	  expect( validate_variations(make_variations, 'core', :all) ).to eq(
	  	[["/sS/0", "required", {"missing_keys"=>["s"]}]]
	  )
  end

  it 'catches bad quality' do
		older['sS'].first['ageState'] = 'great'
		message['sS'].first['q'] = 'great'
	  expect( validate_variations(make_variations, 'core', ['3.1.1','3.1.2']) ).to eq(
	  	[["/sS/0/ageState", "enum"]]
	  )
	  expect( validate_variations(make_variations, 'core', ['3.1.3','3.1.4','3.1.5']) ).to eq(
	  	[["/sS/0/q", "enum"]]
	  )

  end
end
