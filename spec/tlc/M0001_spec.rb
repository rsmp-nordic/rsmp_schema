RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "CommandRequest",
    "siteId" => [
      { "sId" => "RN+SI0001" }
    ],
    "cId" => "O+14439=481WA001",
    "arg" => [
      {
        "cCI" => "M0001",
        "n" => "status",
        "cO" => "setValue",
        "v" => "YellowFlash"
      }
    ]
  }}

  it 'accepts valid command' do
    expect( validate(message, 'tlc') ).to be_nil
  end

  it 'catches bad value' do
    message["arg"].first['v'] = 'bad'
    expect( validate(message, 'tlc',RSMP::Schema.latest_version(:tlc)) ).to eq(
      [["/arg/0/v", "enum"]]
    )
  end

  it 'catches bad name' do
    message["arg"].first['n'] = 'bad'
    expect( validate(message, 'tlc') ).to eq(
      [["/arg/0/n", "enum"]]
    )
  end

  it 'catches bad status values' do
    message["arg"].first['n'] = 'status'
    message["arg"].first['v'] = 'bad'
    expect( validate(message, 'tlc') ).to eq(
      {
        "1.1.1" => [["/arg/0/v", "enum"]],
        ["1.0.7", "1.0.8", "1.0.9", "1.0.10", "1.0.13", "1.0.14", "1.0.15", "1.1"] => [["/arg/0/v", "pattern"]]
      }
    )
  end

  it 'catches bad timeout values' do
    message["arg"].first['n'] = 'timeout'
    message["arg"].first['v'] = 'bad'
    expect( validate(message, 'tlc') ).to eq(
      [["/arg/0/v", "pattern"]]
    )
  end

  it 'catches bad intersection values' do
    message["arg"].first['n'] = 'intersection'
    message["arg"].first['v'] = 'bad'
    expect( validate(message, 'tlc') ).to eq(
      [["/arg/0/v", "pattern"]]
    )
  end

end
