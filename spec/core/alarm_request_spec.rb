RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
		"mType" => "rSMsg",
		"type" => "Alarm",
		"mId" => "E68A0010-C336-41ac-BD58-5C80A72C7092",
		"cId" => "AB+84001=860SG001",
		"aCId" => "A0001",
		"xACId" => "Serious lamp error",
		"aSp" => "Request"
	}}

	it 'accepts valid alarm request from 3.1.5' do
	  expect( validate(message, 'core', '3.1.5') ).to be_nil
  end

	it 'reject valid alarm request before 3.1.5' do
	  expect( validate(message, 'core', ['3.1.1','3.1.2','3.1.3','3.1.4']) ).to eq(
	  	[["/aSp", "enum"]]
	  )
  end

  it 'accepts case variations' do
		valid = message.dup
		valid["aSp"] = 'request'
	  expect( validate(valid, 'core', '3.1.5') ).to be_nil
  end

  it 'catches missing component id' do
		message.delete 'cId'
	  expect( validate(message, 'core', '3.1.5') ).to eq(
	  	[["", "required", {"missing_keys"=>["cId"]}]]
	  )
  end

  it 'catches missing alarm code id' do
		message.delete 'aCId'
	  expect( validate(message, 'core', '3.1.5') ).to eq(
	  	[["", "required", {"missing_keys"=>["aCId"]}]]
	  )
  end

  it 'catches bad alarm code id' do
		message['aCId'] = "001"
	  expect( validate(message, 'core', '3.1.5') ).to eq(
	  	[["/aCId", "pattern"]]
	  )
	end

  it 'catches wrong alarm code id type' do
		message['aCId'] = 123
	  expect( validate(message, 'core', '3.1.5') ).to eq(
	  	[["/aCId", "string"]]
	  )
  end

  it 'catches missing extended alarm code id' do
		message.delete 'xACId'
	  expect( validate(message, 'core', '3.1.5') ).to eq(
	  	[["", "required", {"missing_keys"=>["xACId"]}]]
	  )
  end

  it 'catches wrong extended alarm code id type' do
		message['xACId'] = 123
	  expect( validate(message, 'core', '3.1.5') ).to eq(
	  	[["/xACId", "string"]]
	  )
  end
end
