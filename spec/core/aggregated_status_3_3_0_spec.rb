require 'spec_helper'

RSpec.describe "RSMP 3.3.0 AggregatedStatus bits" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "AggregatedStatus",
    "mId" => "efb6a4c5-f2ea-4947-9deb-667756926203",
    "cId" => "O+14439=481WA001",
    "aSTS" => "2015-06-08T08:05:06.584Z",
    "fP" => nil,
    "fS" => nil,
    "se" => [true,false,false,false,false,false,false,false]
  }}

  it 'accepts bits 2 and 8 set to false' do
    expect(validate message, 'core', '3.3.0').to be_nil
  end

  it 'rejects bit 2 true' do
  message["se"][1] = true
  expect(validate(message, 'core', '3.3.0')).to eq([
      ["/se", "enum"]
    ])
  end

  it 'rejects bit 8 true' do
  message["se"][7] = true
  expect(validate(message, 'core', '3.3.0')).to eq([
      ["/se", "enum"]
    ])
  end
end
