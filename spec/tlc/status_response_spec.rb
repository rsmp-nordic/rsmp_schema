RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusResponse",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
     "sS" => [
       { "sCI" => "S0003", "n" => "inputstatus", "s" => "100101", "q" => "recent" }
     ]
  }}

  it 'accepts valid message' do
    expect(validate message, 'tlc', '1.1').to be_nil
  end

  it 'accepts valid message with q=undefined, s=null' do    
    message["sS"].first["q"] = "undefined"
    message["sS"].first["s"] = nil
    expect(validate message, 'tlc', '1.1').to be_nil
  end
end
