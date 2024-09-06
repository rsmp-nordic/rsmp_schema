RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:request) {{
    "mType" => "rSMsg",
    "type" => "StatusRequest",
    "mId" => "f1a13213-b90a-4abc-8953-2b8142923c55",
    "ntsOId" => "KK+AG9998=001TC000",
    "xNId" => "",
    "cId" => "KK+AG9998=001TC000",
    "sS" => [
      {
        "sCI" => "S0033",
        "n" => "status"
      }
    ]
  }}

  let(:response) {{
    "mType" => "rSMsg",
    "type" => "StatusResponse",
    "mId" => "f1a13213-b90a-4abc-8953-2b8142923c55",
    "ntsOId" => "KK+AG9998=001TC000",
    "xNId" => "",
    "cId" => "KK+AG9998=001TC000",
    "sTs" => "2021-12-13T11:11:07.317Z",
    "sS" => [
      {
        "sCI" => "S0033",
        "n" => "status",
        "q" => "recent",
        "s" => [
          {
            "r" => "f90c",
            "t" => "2021-11-09T15:06:38.796Z",
            "s" => "received"
          },
          {
            "r" => "uhnv",
            "t" => "2021-11-09T15:04:12.348Z",
            "s" => "completed",
            "e" => "5",
            "d" => "10"
          },
          {
            "r" => "oh0i",
            "t" => "2021-11-09T15:06:38.796Z",
            "s" => "activated"
          },
          {
            "r" => "f90c",
            "t" => "2021-11-09T15:06:39.796Z",
            "s" => "completed"
          },
          {
            "r" => "3ia2",
            "t" => "2021-11-09T15:06:48.796Z",
            "s" => "queued",
          },
          {
            "r" => "5hc0",
            "t" => "2021-11-09T15:06:48.796Z",
            "s" => "timeout"
          }
        ]
      }
    ]
  }}

  let(:empty_response) {{
    "mType" => "rSMsg",
    "type" => "StatusResponse",
    "mId" => "f1a13213-b90a-4abc-8953-2b8142923c55",
    "ntsOId" => "KK+AG9998=001TC000",
    "xNId" => "",
    "cId" => "KK+AG9998=001TC000",
    "sTs" => "2021-12-13T11:11:07.317Z",
    "sS" => [
      {
        "sCI" => "S0033",
        "n" => "status",
        "q" => "recent",
        "s" => []
      }
    ]
  }}

  let(:update) {{
    "mType" => "rSMsg",
    "type" => "StatusUpdate",
    "mId" => "f1a13213-b90a-4abc-8953-2b8142923c55",
    "ntsOId" => "KK+AG9998=001TC000",
    "xNId" => "",
    "cId" => "KK+AG9998=001TC000",
    "sTs" => "2021-12-13T11:11:07.317Z",
    "sS" => [
      {
        "sCI" => "S0033",
        "n" => "status",
        "q" => "recent",
        "s" => [
          {
            "r" => "f90c",
            "t" => "2021-11-09T15:06:38.796Z",
            "s" => "received"
          },
          {
            "r" => "uhnv",
            "t" => "2021-11-09T15:04:12.348Z",
            "s" => "completed",
            "e" => "5",
            "d" => "10"
          },
          {
            "r" => "oh0i",
            "t" => "2021-11-09T15:06:38.796Z",
            "s" => "activated"
          },
          {
            "r" => "f90c",
            "t" => "2021-11-09T15:06:39.796Z",
            "s" => "completed"
          },
          {
            "r" => "3ia2",
            "t" => "2021-11-09T15:06:48.796Z",
            "s" => "queued",
          },
          {
            "r" => "5hc0",
            "t" => "2021-11-09T15:06:48.796Z",
            "s" => "timeout"
          }
        ]
      }
    ]
  }}


  it 'accepts from 1.1.0' do
    expect( validate(request, 'tlc', '>=1.1.0') ).to be_nil
    expect( validate(response, 'tlc', '>=1.1.0') ).to be_nil
    expect( validate(empty_response, 'tlc', '>=1.1.0') ).to be_nil
    expect( validate(update, 'tlc', '>=1.1.0') ).to be_nil
  end

  it 'rejects before 1.1' do
    expect( validate(request, 'tlc', '<1.1.0') ).to eq(
      [
        ["/sS/0/sCI", "enum"]
      ]
    )
    expect( validate(response, 'tlc', '<1.1.0') ).to eq(
      [        
        ["/sS/0/sCI", "enum"]
      ]
    )
    expect( validate(empty_response, 'tlc', '<1.1.0') ).to eq(
      [        
        ["/sS/0/sCI", "enum"]
      ]
    )
    expect( validate(update, 'tlc', '<1.1.0') ).to eq(
      [        
        ["/sS/0/sCI", "enum"]
      ]
    )
  end
end
