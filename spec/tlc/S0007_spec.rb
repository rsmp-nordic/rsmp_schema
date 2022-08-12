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

  it 'accepts valid status request' do
    expect( validate(message,'tlc') ).to be_nil
   end
end
