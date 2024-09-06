RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do

  let(:message) {{
    "mType" => "rSMsg",
    "type" => "Alarm",
    "mId" => "efb6a4c5-f2ea-4947-9deb-667756926203",
    "ntsOId" => "KK+AG9998=001TC000",
    "xNId" => "",
    "cId" => "KK+AG9998=001DL001",
    "aCId" => "A0303",
    "xACId" => "ERROR DETECTOR LOGIC OPEN #1",
    "xNACId" => "",
    "aSp" => "Issue",
    "ack" => "notAcknowledged",
    "aS" => "Active",
    "sS" => "notSuspended",
    "aTs" => "2021-12-13T09:35:25.602Z",
    "cat" => "D",
    "pri" => "2",
    "rvs" => [
      {
        "n" => "detector",
        "v" => "1"
      },
      {
        "n" => "type",
        "v" => "loop"
      },
      {
        "n" => "errormode",
        "v" => "on"
      },
      {
        "n" => "manual",
        "v" => "True"
      }
    ]
  }}

  it 'accepts from 1.1.0' do
    expect( validate(message,'tlc', '>=1.1.0') ).to be_nil
   end

  it 'reject before 1.1' do
    expect( validate(message,'tlc', '<1.1.0') ).to eq(
      [["/aCId", "enum"]]
    )
   end
end
