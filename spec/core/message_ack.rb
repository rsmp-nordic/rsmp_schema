RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
	  "mType" => "rSMsg",
	  "type" => "MessageAck",
	  "oMId" => "92b9706d-0466-4518-8663-00b9690e9c41"
	}}

	it 'accepts valid message' do
	  expect( validate(message) ).to be_nil
  end

	it 'catches missing oMId' do
		invalid = message.dup
		invalid.delete 'oMId'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["oMId"]}]
	  ])
  end

  it 'catches bad oMid' do
		invalid = message.dup
		invalid['oMId'] = '4173c2c8a93343cb942566d4613731ed'		# missing dashes
	  expect( validate(invalid) ).to eq([
	  	["/oMId", "pattern"]
	  ])
  end

end
