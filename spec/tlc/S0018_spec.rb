RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do

  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusRequest",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
      "sS" => [
      { "sCI" => "S0018", "n" => "number"},
     ]
  }}

  it 'accepts valid status request for sxl < 1.2' do
    expect( validate(message,'tlc') ).to eq(
      ["1.2", "1.2.1"] => [["/sS/0/sCI", "enum"]]
    )
   end
end
