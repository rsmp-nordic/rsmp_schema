RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "Watchdog",
    "wTs" => "2015-06-08T12:01:39.654Z"
	}}

	it 'accepts valid message' do
	  expect( validate(message) ).to be_nil
  end

  it 'catches missing timestamp' do
		invalid = message.dup
		invalid.delete 'wTs'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["wTs"]}]
	  ])
  end

  it 'catches bad timestamp format' do
		invalid = message.dup
		invalid['wTs'] = '2015-06-08T12:01:39.654' 		# missing Z at end
	  expect( validate(invalid) ).to eq([
	  	["/wTs", "pattern"]
	  ])
  end

end
