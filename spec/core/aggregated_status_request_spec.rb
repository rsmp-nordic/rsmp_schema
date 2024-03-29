RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "AggregatedStatusRequest",
    "mId" => "be12ab9a-800c-4c19-8c50-adf832f22420",
    "cId" => "O+14439=481WA001",
  }}

  it 'accepts aggregated request from 3.1.5' do
    expect( validate(message, 'core', '>=3.1.5') ).to be_nil
  end

  it 'reject alarm aggregated before 3.1.5' do
    expect( validate(message, 'core', '<3.1.5') ).to eq(
      [["/type", "enum"]]
    )
  end

  it 'catches missing mId' do
    message.delete 'mId'
    expect( validate(message, 'core', '>=3.1.5') ).to eq(
      [["", "required", {"missing_keys"=>["mId"]}]]
    )
  end
end