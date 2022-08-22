RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "type" => "CommandRequest",
    "mId" => "e4e9668a-b562-4fbe-9c1e-d4a30733ddea",
    "ntsOId" => "KK+AG9998=001TC000",
    "xNId" => "",
    "cId" => "KK+AG9998=001TC000",
    "arg" => [
      {
         "cCI" => "M0023",
         "n" => "securityCode",
         "cO" => "setTimeout",
         "v" => "0000"
      },
      {
         "cCI" => "M0023",
         "n" => "status",
         "cO" => "setTimeout",
         "v" => "30"
      }
    ]
  }}

  it 'accepts command from 1.1' do
    expect( validate(message, 'tlc', '>=1.1') ).to be_nil
  end

  it 'rejects command before 1.1' do
    expect( validate(message, 'tlc', '<1.1') ).to eq(
      [
        ["/arg/0/cCI", "enum"],
        ["/arg/1/cCI", "enum"]
      ]
    )
  end
end
