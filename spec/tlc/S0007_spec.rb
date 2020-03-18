RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
	let(:message) {{
	  "mType" => "rSMsg",
	  "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
	  "type" => "StatusResponse",
	  "cId" => "O+14439=481WA001",
	  "sTs" => "2015-06-08T09:15:18.266Z",
      "sS" => [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "1,2,3", "q" => "recent" },
	    { "sCI" => "S0007", "n" => "status", "s" => "True,False,True", "q" => "recent" }
	   ]
	}}

	it 'accepts valid status request with a single intersection' do
		message["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "0", "q" => "recent" },
	    { "sCI" => "S0007", "n" => "status", "s" => "True", "q" => "recent" }
	  ]
		expect( validate(message) ).to be_nil

		message["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "0", "q" => "recent" },
	    { "sCI" => "S0007", "n" => "status", "s" => "False", "q" => "recent" }
	  ]
		expect( validate(message) ).to be_nil
 	end

	it 'accepts valid status request with two intersections' do
		message["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "1,2", "q" => "recent" },
	    { "sCI" => "S0007", "n" => "status", "s" => "True,True", "q" => "recent" }
	  ]
		expect( validate(message) ).to be_nil

		message["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "1,2", "q" => "recent" },
	    { "sCI" => "S0007", "n" => "status", "s" => "True,False", "q" => "recent" }
	  ]
		expect( validate(message) ).to be_nil

		message["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "1,2", "q" => "recent" },
	    { "sCI" => "S0007", "n" => "status", "s" => "False,True", "q" => "recent" }
	  ]
		expect( validate(message) ).to be_nil

		message["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "1,2", "q" => "recent" },
	    { "sCI" => "S0007", "n" => "status", "s" => "False,True", "q" => "recent" }
	  ]
		expect( validate(message) ).to be_nil
 	end

	it 'catches bad intersections list' do
		invalid = message.dup
		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "1,2,", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])

		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => ",1,2", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])

		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => ",", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])

		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "1,,2", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])

		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "intersection", "s" => "1,a", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])
 	end

	it 'catches bad intersections list' do
		invalid = message.dup
		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "status", "s" => "True,False,", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])

		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "status", "s" => ",True,False", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])

		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "status", "s" => ",", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])

		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "status", "s" => "True,,False", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])

		invalid["sS"] = [
	    { "sCI" => "S0007", "n" => "status", "s" => "True,1", "q" => "recent" },
	  ]
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/s", "pattern"]
	  ])
 	end
  it 'catches missing component id' do
		invalid = message.dup
		invalid.delete 'cId'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>["cId"]}]
	  ])
  end

  it 'catches bad status code' do
		invalid = message.dup
		invalid['sS'].first['sCI'] = '99'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/sCI", "pattern"],
	  	["/sS/0/sCI", "enum"]
	  ])
  end

  it 'catches missing sS' do
		invalid = message.dup
		invalid.delete 'sS'
	  expect( validate(invalid) ).to eq([
	  	["", "required", {"missing_keys"=>['sS']}]
	  ])
  end

  it 'catches empty sS array' do
		invalid = message.dup
		invalid['sS'].clear
	  expect( validate(invalid) ).to eq([
	  	["/sS", "minItems"]
	  ])
  end

  it 'catches bad sS type' do
		invalid = message.dup
		invalid['sS'] = {}
	  expect( validate(invalid) ).to eq([
	  	["/sS", "array"]
	  ])
  end

  it 'catches missing status code' do
		invalid = message.dup
		invalid['sS'].first.delete 'sCI'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0", "required", {"missing_keys"=>["sCI"]}]
	  ])
  end

  it 'catches bad status code' do
		invalid = message.dup
		invalid['sS'].first['sCI'] = 3
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/sCI", "string"],
	  	["/sS/0/sCI", "enum"]
	  ])

		invalid['sS'].first['sCI'] = '3'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/sCI", "pattern"],
	  	["/sS/0/sCI", "enum"]
	  ])
  end

  it 'catches missing name' do
		invalid = message.dup
		invalid['sS'].first.delete 'n'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0", "required", {"missing_keys"=>["n"]}]
	  ])
  end

  it 'catches bad name' do
		invalid = message.dup
		invalid['sS'].first['n'] = 3
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/n", "string"],
	  	["/sS/0/n", "enum"]
	  ])
  end

  it 'catches missing value' do
		invalid = message.dup
		invalid['sS'].first.delete 's'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0", "required", {"missing_keys"=>["s"]}]
	  ])
  end

  it 'catches missing quality' do
		invalid = message.dup
		invalid['sS'].first.delete 'q'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0", "required", {"missing_keys"=>["q"]}]
	  ])
  end

  it 'catches bad quality' do
		invalid = message.dup
		invalid['sS'].first['q'] = 'great'
	  expect( validate(invalid) ).to eq([
	  	["/sS/0/q", "enum"]
	  ])
  end
end
