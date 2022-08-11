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
	  expect( validate(message, 'core', :all) ).to eq(nil)
  end

  it 'catches missing component id' do
		invalid = message.dup
		invalid.delete 'cId'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["cId"]}]
	  ]})
  end

  it 'catches bad status code' do
		invalid = message.dup
		invalid['sS'].first['sCI'] = '99'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS/0/sCI", "pattern"]
	  ]})
  end

  it 'catches missing sS' do
		invalid = message.dup
		invalid.delete 'sS'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>['sS']}]
	  ]})
  end

  it 'catches empty sS array' do
		invalid = message.dup
		invalid['sS'].clear
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS", "minItems"]
	  ]})
  end

  it 'catches bad sS type' do
		invalid = message.dup
		invalid['sS'] = {}
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS", "array"]
	  ]})
  end

  it 'catches missing status code' do
		invalid = message.dup
		invalid['sS'].first.delete 'sCI'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS/0", "required", {"missing_keys"=>["sCI"]}]
	  ]})
  end

  it 'catches bad status code' do
		invalid = message.dup
		invalid['sS'].first['sCI'] = 3
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS/0/sCI", "string"]
	  ]})

		invalid['sS'].first['sCI'] = '3'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS/0/sCI", "pattern"]
	  ]})
  end

  it 'catches missing name' do
		invalid = message.dup
		invalid['sS'].first.delete 'n'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS/0", "required", {"missing_keys"=>["n"]}]
	  ]})
  end

  it 'catches bad name' do
		invalid = message.dup
		invalid['sS'].first['n'] = 3
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS/0/n", "string"]
	  ]})
  end

  it 'catches extra attributes' do
		invalid = message.dup
		invalid['sS'].first['bad'] = "Foo"
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS/0/bad", "schema"]
	  ]})
  end

end
