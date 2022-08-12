RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "CommandResponse",
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
	  expect( validate(message, 'core', :all) ).to be_nil
  end

  it 'catches missing timestamp' do
		message.delete 'cTS'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["", "required", {"missing_keys"=>["cTS"]}]]
	  )
	end

  it 'catches bad timestamp' do
		message['cTS'] = "2015-06-08T11:49:03:293Z"
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/cTS", "pattern"]]
	  )
	end

  it 'catches missing command response code' do
		message.delete 'cId'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["", "required", {"missing_keys"=>["cId"]}]]
	  )
  end

  it 'catches missing rvs' do
		message.delete 'rvs'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["", "required", {"missing_keys"=>["rvs"]}]]
	  )
  end

  it 'catches bad rvs type' do
		message["rvs"] = {}
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/rvs", "array"]]
	  )
  end

  it 'catches missing command code' do
		message["rvs"].first.delete 'cCI'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/rvs/0", "required", {"missing_keys"=>["cCI"]}]]
	  )
  end

  it 'catches missing name' do
		message["rvs"].first.delete 'n'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/rvs/0", "required", {"missing_keys"=>["n"]}]]
	  )
  end

  it 'catches missing age' do
		message["rvs"].first.delete 'age'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/rvs/0", "required", {"missing_keys"=>["age"]}]]
	  )
  end

  it 'catches bad age' do
		message["rvs"].first['age'] = "new"
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/rvs/0/age", "enum"]]
	  )
  end
  it 'catches missing value' do
		message["rvs"].first.delete 'v'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/rvs/0", "required", {"missing_keys"=>["v"]}]]
	  )
  end

end
