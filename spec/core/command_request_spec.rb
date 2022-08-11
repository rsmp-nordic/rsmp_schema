RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "CommandRequest",
	  "cId" => "O+14439=481WA001",
	  "arg" => [
	    {
	      "cCI" => "M0001",
	      "n" => "status",
	      "cO" => "setValue",
	      "v" => "YellowFlash"
	    }
	  ]
	}}

	it 'accepts valid command' do
	  expect( validate(message, 'core', :all) ).to eq(nil)
  end

  it 'catches missing component id' do
		invalid = message.dup
		invalid.delete 'cId'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["cId"]}]
	  ]})
  end

  it 'catches bad command code' do
		invalid = message.dup
		invalid['arg'].first['cCI'] = '99'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/arg/0/cCI", "pattern"]
	  ]})
  end

  it 'catches missing arg' do
		invalid = message.dup
		invalid.delete 'arg'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["arg"]}]
	  ]})
  end

  it 'catches empty arg array' do
		invalid = message.dup
		invalid["arg"].clear
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/arg", "minItems"]
	  ]})
  end

  it 'catches bad arg type' do
		invalid = message.dup
		invalid["arg"] = {}
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/arg", "array"]
	  ]})
  end

  it 'catches missing command code' do
		invalid = message.dup
		invalid["arg"].first.delete 'cCI'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/arg/0", "required", {"missing_keys"=>["cCI"]}]
	  ]})
  end

  it 'catches bad command code' do
		invalid = message.dup
		invalid["arg"].first['cCI'] = 3
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/arg/0/cCI", "string"]
	  ]})

		invalid["arg"].first['cCI'] = '3'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/arg/0/cCI", "pattern"]
	  ]})
  end

  it 'catches missing name' do
		invalid = message.dup
		invalid["arg"].first.delete 'n'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/arg/0", "required", {"missing_keys"=>["n"]}]
	  ]})
  end

  it 'catches missing command' do
		invalid = message.dup
		invalid["arg"].first.delete 'cO'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/arg/0", "required", {"missing_keys"=>["cO"]}]
	  ]})
  end

  it 'catches missing value' do
		invalid = message.dup
		invalid["arg"].first.delete 'v'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/arg/0", "required", {"missing_keys"=>["v"]}]
	  ]})
  end

end
