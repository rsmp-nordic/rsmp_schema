RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
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
	  expect( validate(message) ).to be_nil
  end

  it 'catches bad value' do
		invalid = message.dup
		invalid["arg"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/v", "enum"]
	  ])
  end

  it 'catches bad name' do
		invalid = message.dup
		invalid["arg"].first['n'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/n", "enum"]
	  ])
  end

  it 'catches bad status values' do
		invalid = message.dup
		invalid["arg"].first['n'] = 'status'
		invalid["arg"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/v", "enum"]
	  ])
  end

  it 'catches bad timeout values' do
		invalid = message.dup
		invalid["arg"].first['n'] = 'timeout'
		invalid["arg"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/v", "pattern"]
	  ])
  end

  it 'catches bad intersection values' do
		invalid = message.dup
		invalid["arg"].first['n'] = 'intersection'
		invalid["arg"].first['v'] = 'bad'
	  expect( validate(invalid) ).to eq([
	  	["/arg/0/v", "pattern"]
	  ])
  end

end
