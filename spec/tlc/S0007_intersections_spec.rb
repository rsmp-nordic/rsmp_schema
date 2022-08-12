RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusResponse",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
      "sS" => [
      { "sCI" => "S0007", "n" => "intersection", "s" => "0", "q" => "recent" },
      { "sCI" => "S0007", "n" => "status", "s" => "True", "q" => "recent" }
     ]
  }}

  it 'accepts valid status request with a single intersection' do
    expect( validate(message,'tlc') ).to be_nil
   end

  it 'accepts valid status request with two intersections' do
    message["sS"] = [
      { "sCI" => "S0007", "n" => "intersection", "s" => "1,2", "q" => "recent" },
      { "sCI" => "S0007", "n" => "status", "s" => "True,True", "q" => "recent" }
    ]
    expect( validate(message,'tlc') ).to be_nil
   end

  it 'catches bad intersections list' do
    # trailing comma
    message["sS"] = [
      { "sCI" => "S0007", "n" => "intersection", "s" => "1,2,", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )

    # leading comma
    message["sS"] = [
      { "sCI" => "S0007", "n" => "intersection", "s" => ",1,2", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )

    # naked comma
    message["sS"] = [
      { "sCI" => "S0007", "n" => "intersection", "s" => ",", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )

    # empty item
    message["sS"] = [
      { "sCI" => "S0007", "n" => "intersection", "s" => "1,,2", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )

    # invalid item
    message["sS"] = [
      { "sCI" => "S0007", "n" => "intersection", "s" => "1,a", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )
   end

  it 'catches bad status list' do
    message["sS"] = [
      { "sCI" => "S0007", "n" => "status", "s" => "True,False,", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )

    message["sS"] = [
      { "sCI" => "S0007", "n" => "status", "s" => ",True,False", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )

    message["sS"] = [
      { "sCI" => "S0007", "n" => "status", "s" => ",", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )

    message["sS"] = [
      { "sCI" => "S0007", "n" => "status", "s" => "True,,False", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )

    message["sS"] = [
      { "sCI" => "S0007", "n" => "status", "s" => "True,1", "q" => "recent" },
    ]
    expect( validate(message,'tlc') ).to eq(
      [["/sS/0/s", "pattern"]]
    )
   end
end
