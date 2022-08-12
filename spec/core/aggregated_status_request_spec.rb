RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
		"mType" => "rSMsg",
		"type" => "AggregatedStatusRequest",
		"mId" => "be12ab9a-800c-4c19-8c50-adf832f22420",
		"cId" => "O+14439=481WA001",
	}}

	it 'accepts valid aggregated request from 3.1.5' do
	  expect( validate(message, 'core') ).to eq({
	  	['3.1.1','3.1.2','3.1.3','3.1.4'] => [["/type", "enum"]]
	  })
  end

	it 'reject valid alarm aggregated before 3.1.5' do
	  expect( validate(message, 'core', ['3.1.1','3.1.2','3.1.3','3.1.4']) ).to eq(
	  	[["/type", "enum"]]
	  )
  end

  it 'catches missing mId' do
		message.delete 'mId'
	  expect( validate(message, 'core', '3.1.5') ).to eq(
	  	[["", "required", {"missing_keys"=>["mId"]}]]
	  )
  end
end