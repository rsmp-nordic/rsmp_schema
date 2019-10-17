RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "StatusUnsubscribe",
	  "cId" => "O+14439=481WA001",
     "sS" => [
	     { "sCI" => "S0003", "n" => "inputstatus" }
	   ]
	}}

	it 'accepts valid status unsubscription' do
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
	  	["/sS/0/sCI", "pattern"],
	  	["/sS/0/sCI", "enum"]
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
	  	["/sS/0/sCI", "string"],
	  	["/sS/0/sCI", "enum"]
	  ])

		invalid['sS'].first['sCI'] = '3'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/sCI", "pattern"],
	  	["/sS/0/sCI", "enum"]
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
	  	["/sS/0/n", "string"],
	  	["/sS/0/n", "enum"]
	  ])
  end

  it 'catches extra attributes' do
		invalid = message.dup
		invalid['sS'].first['bad'] = "Foo"
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/bad", "schema"]
	  ])
  end

end
