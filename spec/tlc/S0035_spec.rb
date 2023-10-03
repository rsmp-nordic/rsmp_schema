RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do

  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusResponse",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
    "sS" => [
      { "sCI" => "S0035", "n" => "emergencyroutes", "s" =>[
        {"id" => "1"},
        {"id" => "2"}
      ], "q" => "recent" }
     ]
  }}

  it 'accepts valid status S0035' do
    expect( validate(message,'tlc', '>=1.2') ).to be_nil
   end

end
