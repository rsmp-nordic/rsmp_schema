RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "Watchdog",
    "wTs" => "2015-06-08T12:01:39.654Z"
	}}

	it 'accepts valid message' do
	  expect( validate(message, 'core', :all) ).to be_nil
  end

  it 'catches missing mId' do
		message.delete 'mId'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["", "required", {"missing_keys"=>["mId"]}]]
	  )
  end

  it 'catches missing timestamp' do
		message.delete 'wTs'
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["", "required", {"missing_keys"=>["wTs"]}]]
	  )
  end

  it 'catches bad timestamp format' do
		message['wTs'] = '2015-06-08T12:01:39.654' 		# missing Z at end
	  expect( validate(message, 'core', :all) ).to eq(
	  	[["/wTs", "pattern"]]
	  )
  end

end
