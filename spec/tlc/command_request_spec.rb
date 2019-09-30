RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:version) {{
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

	let(:ack) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "siteId" => [
	    { "sId" => "RN+SI0001" }
	  ],
	  "type" => "MessageAck",
	  "oMId" => "92b9706d-0466-4518-8663-00b9690e9c41"
	}}

	let(:status) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "StatusRequest",
	  "siteId" => [
	    { "sId" => "RN+SI0001" }
	  ],
	  "cId" => "O+14439=481WA001"
	}}

	let(:command) {{
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

	it 'accepts valid command' do
	  expect( validate(command) ).to be_nil
  end

  it 'catches missing command code' do
		invalid = command.dup
		invalid.delete 'cId'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["cId"]}]
	  ])
  end

  it 'catches bad command code' do
		invalid = command.dup
		invalid['arg'].first['cCI'] = 'M0099'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/cCI", "enum"]
	  ])
  end

  it 'catches missing arg' do
		invalid = command.dup
		invalid.delete 'arg'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["arg"]}]
	  ])
  end

  it 'catches empty arg array' do
		invalid = command.dup
		invalid["arg"].clear
	  expect( validate(invalid) ).to eq([
	  	["/arg", "minItems"]
	  ])
  end

  it 'catches bad arg type' do
		invalid = command.dup
		invalid["arg"] = {}
	  expect( validate(invalid) ).to eq([
	  	["/arg", "array"]
	  ])
  end

  it 'catches missing command code' do
		invalid = command.dup
		invalid["arg"].first.delete 'cCI'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0", "required", {"missing_keys"=>["cCI"]}]
	  ])
  end

  it 'catches missing name' do
		invalid = command.dup
		invalid["arg"].first.delete 'n'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0", "required", {"missing_keys"=>["n"]}]
	  ])
  end

  it 'catches missing command' do
		invalid = command.dup
		invalid["arg"].first.delete 'cO'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0", "required", {"missing_keys"=>["cO"]}]
	  ])
  end

  it 'catches missing value' do
		invalid = command.dup
		invalid["arg"].first.delete 'v'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0", "required", {"missing_keys"=>["v"]}]
	  ])
  end

  it 'catches bad value' do
		invalid = command.dup
		invalid["arg"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/v", "enum"]
	  ])
  end

  it 'catches bad name' do
		invalid = command.dup
		invalid["arg"].first['n'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/n", "enum"]
	  ])
  end

  it 'catches bad status values' do
		invalid = command.dup
		invalid["arg"].first['n'] = 'status'
		invalid["arg"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/v", "enum"]
	  ])
  end

  it 'catches bad timeout values' do
		invalid = command.dup
		invalid["arg"].first['n'] = 'timeout'
		invalid["arg"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/v", "pattern"]
	  ])
  end

  it 'catches bad intersection values' do
		invalid = command.dup
		invalid["arg"].first['n'] = 'intersection'
		invalid["arg"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/v", "pattern"]
	  ])
  end

end
