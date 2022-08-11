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

	it 'accepts valid alarm request' do
	  expect( validate(message, 'core', :all) ).to eq(nil)
  end

  it 'catches missing component id' do
		invalid = message.dup
		invalid.delete 'cId'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["cId"]}]
	  ]})
  end

  it 'catches missing alarm code id' do
		invalid = message.dup
		invalid.delete 'aCId'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["aCId"]}]
	  ]})
  end

  it 'catches bad alarm code id' do
		invalid = message.dup
		invalid['aCId'] = "001"
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/aCId", "pattern"]
	  ]})
	end

  it 'catches wrong alarm code id type' do
		invalid = message.dup
		invalid['aCId'] = 123
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/aCId", "string"]
	  ]})
  end

  it 'catches missing extended alarm code id' do
		invalid = message.dup
		invalid.delete 'xACId'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["xACId"]}]
	  ]})
  end

  it 'catches wrong extended alarm code id type' do
		invalid = message.dup
		invalid['xACId'] = 123
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/xACId", "string"]
	  ]})
  end

  it 'catches missing state' do
		invalid = message.dup
		invalid.delete 'aSp'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["aSp"]}]
	  ]})
  end

  it 'catches bad state' do
		invalid = message.dup
		invalid['aSp'] = "Bad"
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/aSp", "enum"]
	  ]})
	end

  it 'catches wrong state type' do
		invalid = message.dup
		invalid['aSp'] = 123
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/aSp", "enum"],
	  	["/aSp", "string"]
	  ]})
  end

  it 'catches missing alarm code id' do
		invalid = message.dup
		invalid.delete 'aS'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["aS"]}]
	  ]})
  end

  it 'catches bad alarm code id' do
		invalid = message.dup
		invalid['aS'] = "Bad"
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/aS", "enum"]
	  ]})
	end

  it 'catches wrong alarm code id type' do
		invalid = message.dup
		invalid['aS'] = 123
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/aS", "enum"],
	  	["/aS", "string"]
	  ]})
  end

  it 'catches missing alarm code id' do
		invalid = message.dup
		invalid.delete 'sS'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["sS"]}]
	  ]})
  end

  it 'catches bad alarm code id' do
		invalid = message.dup
		invalid['sS'] = "Bad"
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS", "enum"]
	  ]})
	end

  it 'catches wrong alarm code id type' do
		invalid = message.dup
		invalid['sS'] = 123
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/sS", "enum"],
	  	["/sS", "string"]
	  ]})
  end

  it 'catches missing alarm code id' do
		invalid = message.dup
		invalid.delete 'ack'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["ack"]}]
	  ]})
  end

  it 'catches bad alarm code id' do
		invalid = message.dup
		invalid['ack'] = "Bad"
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/ack", "enum"]
	  ]})
	end

  it 'catches wrong alarm code id type' do
		invalid = message.dup
		invalid['ack'] = 123
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/ack", "enum"],
	  	["/ack", "string"]
	  ]})
  end

  it 'catches missing category' do
		invalid = message.dup
		invalid.delete 'cat'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["cat"]}]
	  ]})
  end

  it 'catches bad category' do
		invalid = message.dup
		invalid['cat'] = "A"
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/cat", "enum"]
	  ]})
	end

  it 'catches wrong category' do
		invalid = message.dup
		invalid['cat'] = 123
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/cat", "enum"],
	  	["/cat", "string"]
	  ]})
  end

  it 'catches missing priority' do
		invalid = message.dup
		invalid.delete 'pri'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["pri"]}]
	  ]})
  end

  it 'catches bad priority' do
		invalid = message.dup
		invalid['pri'] = "4"
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/pri", "enum"]
	  ]})
	end

  it 'catches wrong priority' do
		invalid = message.dup
		invalid['pri'] = 1
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/pri", "enum"],
	  	["/pri", "string"]
	  ]})
  end

  it 'catches missing timestamp' do
		invalid = message.dup
		invalid.delete 'aTs'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["aTs"]}]
	  ]})
  end

  it 'catches bad timestamp' do
		invalid = message.dup
		invalid['aTs'] = "yesterday"
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/aTs", "pattern"]
	  ]})
	end

  it 'catches wrong timestamp type' do
		invalid = message.dup
		invalid['aTs'] = 123
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/aTs", "string"]
	  ]})
  end

  it 'catches missing rvs' do
		invalid = message.dup
		invalid.delete 'rvs'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["", "required", {"missing_keys"=>["rvs"]}]
	  ]})
  end

  it 'catches bad rvs type' do
		invalid = message.dup
		invalid["rvs"] = {}
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/rvs", "array"]
	  ]})
  end

  it 'catches missing alarm name' do
		invalid = message.dup
		invalid["rvs"].first.delete 'n'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/rvs/0", "required", {"missing_keys"=>["n"]}]
	  ]})
  end

  it 'catches bad alarm name' do
		invalid = message.dup
		invalid["rvs"].first['n'] = 3
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/rvs/0/n", "string"]
	  ]})
  end

  it 'catches missing alarm value' do
		invalid = message.dup
		invalid["rvs"].first.delete 'v'
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/rvs/0", "required", {"missing_keys"=>["v"]}]
	  ]})
  end

  it 'catches bad alarm value' do
		invalid = message.dup
		invalid["rvs"].first['v'] = 3
	  expect( validate(invalid, 'core', :all) ).to eq({ all: [
	  	["/rvs/0/v", "string"]
	  ]})
  end

end
