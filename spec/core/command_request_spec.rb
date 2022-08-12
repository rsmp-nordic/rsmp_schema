RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "CommandRequest",
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
    expect( validate(message, 'core') ).to be_nil
  end

  it 'catches missing component id' do
    message.delete 'cId'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["cId"]}]]
    )
  end

  it 'catches bad command code' do
    message['arg'].first['cCI'] = '99'
    expect( validate(message, 'core') ).to eq(
      [["/arg/0/cCI", "pattern"]]
    )
  end

  it 'catches missing arg' do
    message.delete 'arg'
    expect( validate(message, 'core') ).to eq(
      [["", "required", {"missing_keys"=>["arg"]}]]
    )
  end

  it 'catches empty arg array' do
    message["arg"].clear
    expect( validate(message, 'core') ).to eq(
      [["/arg", "minItems"]]
    )
  end

  it 'catches bad arg type' do
    message["arg"] = {}
    expect( validate(message, 'core') ).to eq(
      [["/arg", "array"]]
    )
  end

  it 'catches missing command code' do
    message["arg"].first.delete 'cCI'
    expect( validate(message, 'core') ).to eq(
      [["/arg/0", "required", {"missing_keys"=>["cCI"]}]]
    )
  end

  it 'catches bad command code' do
    message["arg"].first['cCI'] = 3
    expect( validate(message, 'core') ).to eq(
      [["/arg/0/cCI", "string"]]
    )

    message["arg"].first['cCI'] = '3'
    expect( validate(message, 'core') ).to eq(
      [["/arg/0/cCI", "pattern"]]
    )
  end

  it 'catches missing name' do
    message["arg"].first.delete 'n'
    expect( validate(message, 'core') ).to eq(
      [["/arg/0", "required", {"missing_keys"=>["n"]}]]
    )
  end

  it 'catches missing command' do
    message["arg"].first.delete 'cO'
    expect( validate(message, 'core') ).to eq(
      [["/arg/0", "required", {"missing_keys"=>["cO"]}]]
    )
  end

  it 'catches missing value' do
    message["arg"].first.delete 'v'
    expect( validate(message, 'core') ).to eq(
      [["/arg/0", "required", {"missing_keys"=>["v"]}]]
    )
  end

end
