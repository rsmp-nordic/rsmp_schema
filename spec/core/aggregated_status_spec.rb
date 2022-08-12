RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
		"mType" => "rSMsg",
		"type" => "AggregatedStatus",
		"mId" => "be12ab9a-800c-4c19-8c50-adf832f22420",
		"cId" => "O+14439=481WA001",
		"aSTS" => "2015-06-08T08:05:06.584Z",
		"fP" => nil,
		"fS" => nil,
		"se" => [
			true,false,false,false,false,false,false,false
		]
	}}

	it 'accepts valid message' do
	  expect( validate(message, 'core') ).to be_nil
  end

  it 'catches missing mId' do
		message.delete 'mId'
	  expect( validate(message, 'core') ).to eq(
	  	[["", "required", {"missing_keys"=>["mId"]}]]
	  )
  end

  it 'catches missing aSTS' do
		message.delete 'aSTS'
	  expect( validate(message, 'core') ).to eq(
	  	[["", "required", {"missing_keys"=>["aSTS"]}]]
	  )
  end

  it 'catches bad aSTS' do
		message['aSTS'] = "2015-06-08T08:05:06.5843Z"
	  expect( validate(message, 'core') ).to eq(
	  	[["/aSTS", "pattern"]]
	  )
  end

  it 'catches missing se' do
		message.delete 'se'
	  expect( validate(message, 'core') ).to eq(
	  	[["", "required", {"missing_keys"=>["se"]}]]
	  )
  end

  it 'catches bad se' do
		message['se'] = 123
	  expect( validate(message, 'core') ).to eq(
	  	[["/se", "array"]]
	  )

		message['se'] = [true,false,false,false,false,false,false]
	  expect( validate(message, 'core') ).to eq(
	  	[["/se", "minItems"]]
	  )

		message['se'] = [true,false,false,false,false,false,false,true,true]
	  expect( validate(message, 'core') ).to eq(
	  	[["/se", "maxItems"]]
	  )

		message['se'] = [false,false,false,1,nil,"",false,false]
	  expect( validate(message, 'core') ).to eq(
	  	[["/se/3", "boolean"],
	  	["/se/4", "boolean"],
	  	["/se/5", "boolean"]]
	  )

	end

end