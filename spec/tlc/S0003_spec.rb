RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do

  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusRequest",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
    "sS" => [
      { "sCI" => "S0003", "n" => "inputstatus" },
     ]
  }}

  let(:message_extended) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusRequest",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
    "sS" => [
      { "sCI" => "S0003", "n" => "inputstatus" },
      { "sCI" => "S0003", "n" => "extendedinputstatus" }
     ]
  }}

  it 'accepts valid S0003 status reqeust, extendedinputstatus' do
    expect( validate(message_extended,'tlc') ).to eq(
     {["1.2.0","1.2.1"]=>[["/sS/1/n", "enum"]]}
    )
  end
end
