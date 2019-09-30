RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
	  "mType" => "rSMsg",
	  "mId" => "a28e94b9-05c7-41bb-8f8b-54693adc9698",
	  "siteId" => [
	    { "sId" => "RN+SI0001" }
	  ],
	  "type" => "Version",
	  "RSMP" => [
	    { "vers" => "3.1.1" },
	    { "vers" => "3.1.2" },
	    { "vers" => "3.1.3" },
	    { "vers" => "3.1.4" }
	  ],
	  "SXL" => "1.1"
	}}

	it 'accepts valid message' do
	  expect( validate(message) ).to be_nil
  end

  it 'catches missing site id' do
		invalid = message.dup
		invalid.delete 'siteId'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["siteId"]}]
	  ])
  end

end
