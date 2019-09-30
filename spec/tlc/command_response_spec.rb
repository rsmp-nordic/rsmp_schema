RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do

	let(:message) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "CommandResponse",
	  "siteId" => [
	    { "sId" => "RN+SI0001" }
	  ],
	  "cId" => "O+14439=481WA001",
	  "cTS" => "2015-06-08T11:49:03.293Z",
	  "rvs" => [
	    {
	      "cCI" => "M0001",
	      "n" => "status",
	      "v" => "YellowFlash",
	      "age" => "recent"
	    }
	  ]
	}}

	it 'accepts valid command response' do
	  expect( validate(message) ).to be_nil
  end

  it 'catches missing timestamp' do
		invalid = message.dup
		invalid.delete 'cTS'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["cTS"]}]
	  ])
	end

  it 'catches bad timestamp' do
		invalid = message.dup
		invalid['cTS'] = "2015-06-08T11:49:03:293Z"
	  expect( validate(invalid) ).to eq([
	  	["/cTS", "pattern"]
	  ])
	end

  it 'catches missing command response code' do
		invalid = message.dup
		invalid.delete 'cId'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["cId"]}]
	  ])
  end

  it 'catches missing rvs' do
		invalid = message.dup
		invalid.delete 'rvs'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["rvs"]}]
	  ])
  end

  it 'catches empty rvs array' do
		invalid = message.dup
		invalid["rvs"].clear
	  expect( validate(invalid) ).to eq([
	  	["/rvs", "minItems"]
	  ])
  end

  it 'catches bad rvs type' do
		invalid = message.dup
		invalid["rvs"] = {}
	  expect( validate(invalid) ).to eq([
	  	["/rvs", "array"]
	  ])
  end

  it 'catches missing command code' do
		invalid = message.dup
		invalid["rvs"].first.delete 'cCI'
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0", "required", {"missing_keys"=>["cCI"]}]
	  ])
  end

  it 'catches missing name' do
		invalid = message.dup
		invalid["rvs"].first.delete 'n'
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0", "required", {"missing_keys"=>["n"]}]
	  ])
  end

  it 'catches missing age' do
		invalid = message.dup
		invalid["rvs"].first.delete 'age'
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0", "required", {"missing_keys"=>["age"]}]
	  ])
  end

  it 'catches bad age' do
		invalid = message.dup
		invalid["rvs"].first['age'] = "new"
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0/age", "enum"]
	  ])
  end
  it 'catches missing value' do
		invalid = message.dup
		invalid["rvs"].first.delete 'v'
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0", "required", {"missing_keys"=>["v"]}]
	  ])
  end

  it 'catches bad value' do
		invalid = message.dup
		invalid["rvs"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0/v", "enum"]
	  ])
  end

  it 'catches bad name' do
		invalid = message.dup
		invalid["rvs"].first['n'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0/n", "enum"]
	  ])
  end

  it 'catches bad status values' do
		invalid = message.dup
		invalid["rvs"].first['n'] = 'status'
		invalid["rvs"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0/v", "enum"]
	  ])
  end

  it 'catches bad timeout values' do
		invalid = message.dup
		invalid["rvs"].first['n'] = 'timeout'
		invalid["rvs"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0/v", "pattern"]
	  ])
  end

  it 'catches bad intersection values' do
		invalid = message.dup
		invalid["rvs"].first['n'] = 'intersection'
		invalid["rvs"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/rvs/0/v", "pattern"]
	  ])
  end

end
