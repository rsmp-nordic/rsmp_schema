require 'spec_helper'

RSpec.describe "RSMP 3.3.0 CommandRequest single command" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "CommandRequest",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "cId" => "O+14439=481WA001",
    "arg" => [
      { "cCI" => "M0001", "n" => "status", "cO" => "setValue", "v" => "YellowFlash" }
    ]
  }}

  it 'accepts single command across versions' do
    expect(validate message, 'core', :all).to be_nil
  end

  it 'rejects multiple commands in 3.3.0 but allow it in earlier versions' do
  message["arg"] << { "cCI" => "M0002", "n" => "mode", "cO" => "setValue", "v" => "NormalControl" }
    # Earlier versions should allow
  expect(validate message, 'core', '<3.3.0').to be_nil
    # 3.3.0 should reject
  expect(validate(message, 'core', '3.3.0')).to eq([["/arg", "maxItems"]])
  end
end
