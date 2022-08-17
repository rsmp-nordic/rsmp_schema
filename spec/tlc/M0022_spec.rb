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
         "cCI" => "M0022",
         "n" => "requestId",
         "cO" => "requestPriority",
         "v" => "f90c"
      },
      {
         "cCI" => "M0022",
         "n" => "connectionId",
         "cO" => "requestPriority",
         "v" => "5"
      },
      {
         "cCI" => "M0022",
         "n" => "type",
         "cO" => "requestPriority",
         "v" => "new"
      },
      {
         "cCI" => "M0022",
         "n" => "level",
         "cO" => "requestPriority",
         "v" => "14"
      },
      {
         "cCI" => "M0022",
         "n" => "eta",
         "cO" => "requestPriority",
         "v" => "20"
      },
      {
         "cCI" => "M0022",
         "n" => "vehicleType",
         "cO" => "requestPriority",
         "v" => "bus"
      }
    ]
  }}

  it 'accepts valid command from 1.1' do
    expect( validate(message, 'tlc', '>=1.1') ).to be_nil
  end

  it 'accepts valid command from 1.1' do
    expect( validate(message, 'tlc', '<1.1') ).to eq(
      [
        ["/arg/0/cCI", "enum"],
        ["/arg/1/cCI", "enum"],
        ["/arg/2/cCI", "enum"],
        ["/arg/3/cCI", "enum"],
        ["/arg/4/cCI", "enum"],
        ["/arg/5/cCI", "enum"]
      ]
    )
  end
end
