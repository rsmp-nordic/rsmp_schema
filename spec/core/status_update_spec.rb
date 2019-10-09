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

	it 'accepts valid status request' do
	  expect( validate(message) ).to be_nil
  end

  it 'catches missing component id' do
		invalid = message.dup
		invalid.delete 'cId'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["cId"]}]
	  ])
  end

  it 'catches bad status code' do
		invalid = message.dup
		invalid['sS'].first['sCI'] = '99'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/sCI", "pattern"]
	  ])
  end

  it 'catches missing sS' do
		invalid = message.dup
		invalid.delete 'sS'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>['sS']}]
	  ])
  end

  it 'catches empty sS array' do
		invalid = message.dup
		invalid['sS'].clear
	  expect( validate(invalid) ).to eq([
	  	["/sS", "minItems"]
	  ])
  end

  it 'catches bad sS type' do
		invalid = message.dup
		invalid['sS'] = {}
	  expect( validate(invalid) ).to eq([
	  	["/sS", "array"]
	  ])
  end

  it 'catches missing status code' do
		invalid = message.dup
		invalid['sS'].first.delete 'sCI'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0", "required", {"missing_keys"=>["sCI"]}]
	  ])
  end

  it 'catches bad status code' do
		invalid = message.dup
		invalid['sS'].first['sCI'] = 3
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/sCI", "string"]
	  ])

		invalid['sS'].first['sCI'] = '3'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/sCI", "pattern"]
	  ])
  end

  it 'catches missing name' do
		invalid = message.dup
		invalid['sS'].first.delete 'n'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0", "required", {"missing_keys"=>["n"]}]
	  ])
  end

  it 'catches bad name' do
		invalid = message.dup
		invalid['sS'].first['n'] = 3
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/n", "string"]
	  ])
  end

  it 'catches missing value' do
		invalid = message.dup
		invalid['sS'].first.delete 's'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0", "required", {"missing_keys"=>["s"]}]
	  ])
  end

  it 'catches missing quality' do
		invalid = message.dup
		invalid['sS'].first.delete 'q'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0", "required", {"missing_keys"=>["q"]}]
	  ])
  end

  it 'catches bad quality' do
		invalid = message.dup
		invalid['sS'].first['q'] = 'great'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/q", "enum"]
	  ])
  end
end
