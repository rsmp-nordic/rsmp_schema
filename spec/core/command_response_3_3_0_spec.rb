require 'spec_helper'

RSpec.describe "RSMP 3.3.0 CommandResponse single command" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "CommandResponse",
    "mId" => "e4e9668a-b562-4fbe-9c1e-d4a30733ddea",
    "cId" => "O+14439=481WA001",
    "cTS" => "2015-06-08T11:49:03.293Z",
    "rvs" => [
      { "cCI" => "M0001", "n" => "status", "v" => "YellowFlash", "age" => "recent" }
    ]
  }}

  it 'accepts single response across versions' do
    expect(validate message, 'core', :all).to be_nil
  end

  it 'rejects multiple responses in 3.3.0 but allows earlier versions' do
  message["rvs"] << { "cCI" => "M0002", "n" => "mode", "v" => "NormalControl", "age" => "recent" }
  expect(validate message, 'core', '<3.3.0').to be_nil
  expect(validate(message, 'core', '3.3.0')).to eq([["/rvs", "maxItems"]])
  end
end
