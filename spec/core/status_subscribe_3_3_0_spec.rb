require 'spec_helper'

RSpec.describe "RSMP 3.3.0 StatusSubscribe message" do
  let(:base_message) {{
    "mType" => "rSMsg",
    "type" => "StatusSubscribe",
    "mId" => "1a2b3c4d-1234-4567-8901-123456789abc",
    "cId" => "O+14439=481WA001",
    "sS" => [
      {
        "sCI" => "S0001",
        "n" => "signalGroupStatus",
        "uRt" => "2.5",
        "sOc" => false
      }
    ]
  }}

  describe "uRt (updateRate) field" do
    it 'accepts number as string with decimal' do
      message = base_message.dup
      message["sS"][0]["uRt"] = "2.5"
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'accepts integer as string' do
      message = base_message.dup
      message["sS"][0]["uRt"] = "5"
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'accepts zero as string' do
      message = base_message.dup
      message["sS"][0]["uRt"] = "0"
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'accepts negative numbers' do
      message = base_message.dup
      message["sS"][0]["uRt"] = "-1.5"
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'rejects non-numeric strings' do
      message = base_message.dup
      message["sS"][0]["uRt"] = "invalid"
      expect(validate message, 'core', '3.3.0').to eq([
        ["/sS/0/uRt", "pattern"]
      ])
    end

    it 'rejects actual numbers (not strings)' do
      message = base_message.dup
      message["sS"][0]["uRt"] = 2.5
      expect(validate message, 'core', '3.3.0').to eq([
        ["/sS/0/uRt", "string"]
      ])
    end

    it 'requires uRt field' do
      message = base_message.dup
      message["sS"][0].delete("uRt")
      expect(validate message, 'core', '3.3.0').to eq([
        ["/sS/0", "required", {"missing_keys"=>["uRt"]}]
      ])
    end
  end

  describe "backward compatibility" do
    it 'still works with older versions that used integer format' do
      message = base_message.dup
      message["sS"][0]["uRt"] = "5"  # integer format still works
      expect(validate message, 'core', ['3.1.5', '3.2.0', '3.2.1', '3.2.2']).to be_nil
    end
  end
end