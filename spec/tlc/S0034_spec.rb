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
        "sCI" => "S0034",
        "n" => "status"
      }
    ]
  }}

  let(:response) {{
    "mType" => "rSMsg",
    "type" => "StatusResponse",
    "mId" => "c4064647-65c8-4ebd-aa41-e52576329d8e",
    "ntsOId" => "KK+AG9998=001TC000",
    "xNId" => "",
    "cId" => "KK+AG9998=001TC000",
    "sTs" => "2021-12-13T11:55:13.399Z",
    "sS" => [
      {
        "sCI" => "S0034",
        "n" => "status",
        "s" => "30",
        "q" => "recent"
      }
    ]
  }}

  it 'accepts from 1.1' do
    expect( validate(request, 'tlc', '>=1.1.0') ).to be_nil
    expect( validate(response, 'tlc', '>=1.1.0') ).to be_nil
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
  end
end
