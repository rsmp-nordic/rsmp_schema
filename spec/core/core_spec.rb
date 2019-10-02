RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "CommandRequest",
	  "siteId" => [
	    { "sId" => "RN+SI0001" }
	  ],
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

	it 'accepts valid message' do
	  expect( validate(message) ).to be_nil
  end

  it 'catches missing mType' do
		invalid = message.dup
		invalid.delete 'mType'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["mType"]}]
	  ])
  end

  it 'catches missing mId' do
		invalid = message.dup
		invalid.delete 'mId'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["mId"]}]
	  ])
  end

  it 'catches missing type' do
		invalid = message.dup
		invalid.delete 'type'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["type"]}]
	  ])
  end

  it 'catches bad mType' do
		invalid = message.dup
		invalid['mType'] = 'ohno'
	  expect( validate(invalid) ).to eq([
	  	["/mType", "const"]
	  ])
  end

  it 'catches bad mId' do
		invalid = message.dup
		invalid['mId'] = '4173c2c8a93343cb942566d4613731ed'		# missing dashes
	  expect( validate(invalid) ).to eq([
	  	["/mId", "pattern"]
	  ])
  end

  it 'catches bad type' do
		invalid = message.dup
		invalid['type'] = 'MyMessage'
	  expect( validate(invalid) ).to eq([
	  	["/type", "enum"]
	  ])
  end

end
