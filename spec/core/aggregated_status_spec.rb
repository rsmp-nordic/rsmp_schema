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
	  expect( validate(message) ).to be_nil
  end

  it 'catches missing mType' do
		invalid = message.dup
		invalid.delete 'mType'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["mType"]}]
	  ])
  end

end