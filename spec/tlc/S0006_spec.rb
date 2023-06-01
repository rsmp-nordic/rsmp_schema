RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do

  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusResponse",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
    "sS" => [
      { "sCI" => "S0006", "n" => "emergencystage", "s" => "1", "q" => "recent" },
      { "sCI" => "S0006", "n" => "status", "s" => "True", "q" => "recent" }
     ]
  }}

  it 'accepts valid status S0006, route is active' do
    expect( validate(message,'tlc') ).to be_nil
   end

  it 'accepts valid status S0006, route is inactive' do
    message['sS'][1]['s'] = 'False'
    expect( validate(message,'tlc') ).to be_nil
   end

  it 'accepts valid status S0006, no route active' do
    message['sS'][0]['s'] = '0'
    message['sS'][1]['s'] = 'False'
    expect( validate(message,'tlc') ).to be_nil
   end

end
