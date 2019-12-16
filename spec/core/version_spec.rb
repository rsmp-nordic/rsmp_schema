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

  it 'catches missing mId' do
		invalid = message.dup
		invalid.delete 'mId'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["mId"]}]
	  ])
  end

  it 'catches missing siteId' do
		invalid = message.dup
		invalid.delete 'siteId'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["siteId"]}]
	  ])
  end

  it 'catches bad siteId format, must be array' do
		invalid = message.dup
		invalid['siteId'] = '1.0'
	  expect( validate(invalid) ).to eq([
	  	["/siteId", "array"]
	  ])
  end

  it 'catches bad siteId format, array cannot be empty' do
		invalid = message.dup
		invalid['siteId'] = []
	  expect( validate(invalid) ).to eq([
	  	["/siteId", "minItems"]
	  ])
  end

  it 'catches bad siteId format, item must be hash' do
		invalid = message.dup
		invalid['siteId'] = ['1.0']
	  expect( validate(invalid) ).to eq([
	  	["/siteId/0", "object"]
	  ])
  end

  it 'catches bad siteId format, item must have version' do
		invalid = message.dup
		invalid['siteId'] = [{}]
	  expect( validate(invalid) ).to eq([
	  	["/siteId/0", "required", {"missing_keys"=>["sId"]}]
	  ])
  end

  it 'catches bad siteId format, item cannot have extra attributes' do
		invalid = message.dup
		invalid['siteId'] = [{'sId'=>'RN+SI0001','extra'=>'123'}]
	  expect( validate(invalid) ).to eq([
	  	["/siteId/0/extra", "schema"]
	  ])
  end

  it 'catches missing RSMP version' do
		invalid = message.dup
		invalid.delete 'RSMP'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["RSMP"]}]
	  ])
  end

  it 'catches bad RSMP format, must be array' do
		invalid = message.dup
		invalid['RSMP'] = '1.0'
	  expect( validate(invalid) ).to eq([
	  	["/RSMP", "array"]
	  ])
  end

  it 'catches bad RSMP format, array cannot be empty' do
		invalid = message.dup
		invalid['RSMP'] = []
	  expect( validate(invalid) ).to eq([
	  	["/RSMP", "minItems"]
	  ])
  end

  it 'catches bad RSMP format, item must be hash' do
		invalid = message.dup
		invalid['RSMP'] = ['1.0']
	  expect( validate(invalid) ).to eq([
	  	["/RSMP/0", "object"]
	  ])
  end

  it 'catches bad RSMP format, item must have version' do
		invalid = message.dup
		invalid['RSMP'] = [{}]
	  expect( validate(invalid) ).to eq([
	  	["/RSMP/0", "required", {"missing_keys"=>["vers"]}]
	  ])
  end

  it 'catches bad RSMP format, item cannot have extra attributes' do
		invalid = message.dup
		invalid['RSMP'] = [{'vers'=>'1.0.0','extra'=>'123'}]
	  expect( validate(invalid) ).to eq([
	  	["/RSMP/0/extra", "schema"]
	  ])
  end

  it 'catches bad RSMP format, version must be 1.0.0 format' do
		invalid = message.dup
		invalid['RSMP'].first['vers'] = 'latest'
	  expect( validate(invalid) ).to eq([
	  	["/RSMP/0/vers", "pattern"]
	  ])
  end

  it 'catches missing SXL version' do
		invalid = message.dup
		invalid.delete 'SXL'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["SXL"]}]
	  ])
  end

  it 'catches bad SXL version' do
		invalid = message.dup
		invalid['SXL'] = 'Release 1.0.1'
	  expect( validate(invalid) ).to eq([
	  	["/SXL", "pattern"]
	  ])
  end
end
