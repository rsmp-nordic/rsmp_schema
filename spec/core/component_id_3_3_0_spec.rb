require 'spec_helper'

RSpec.describe "RSMP 3.3.0 Component ID formats" do
  let(:base_message) {{
    "mType" => "rSMsg",
    "type" => "StatusRequest",
    "mId" => "1a2b3c4d-1234-4567-8901-123456789abc",
    "sS" => [
      {
        "sCI" => "S0001",
        "n" => "signalGroupStatus"
      }
    ]
  }}

  describe "Format A (traditional)" do
    it 'accepts traditional component id format' do
      message = base_message.dup
      message["cId"] = "KK+AG0503=001DL001"
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'accepts variations of format A' do
      message = base_message.dup
      message["cId"] = "AB+12345=999TL123"
      expect(validate message, 'core', '3.3.0').to be_nil
    end
  end

  describe "Format B (hierarchical)" do
    it 'accepts simple hierarchical component ids' do
      message = base_message.dup
      message["cId"] = "/tc"
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'accepts multi-level hierarchical component ids' do
      message = base_message.dup
      message["cId"] = "/sg/1"
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'accepts deep hierarchical component ids' do
      message = base_message.dup
      message["cId"] = "/in/1/sg/6"
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'accepts component ids with descriptive names' do
      message = base_message.dup
      message["cId"] = "/dl/radar/1"
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'rejects component ids ending with slash' do
      message = base_message.dup
      message["cId"] = "/sg/"
      expect(validate message, 'core', '3.3.0').not_to be_nil
    end

    it 'rejects component ids with empty segments' do
      message = base_message.dup
      message["cId"] = "/sg//1"
      expect(validate message, 'core', '3.3.0').not_to be_nil
    end
  end

  describe "Main component references" do
    it 'accepts empty string for main component' do
      message = base_message.dup
      message["cId"] = ""
      expect(validate message, 'core', '3.3.0').to be_nil
    end

    it 'accepts null for main component' do
      message = base_message.dup
      message["cId"] = nil
      expect(validate message, 'core', '3.3.0').to be_nil
    end
  end

  describe "Invalid formats" do
    it 'rejects component ids without proper format' do
      message = base_message.dup
      message["cId"] = "invalid-component-id"
      expect(validate message, 'core', '3.3.0').not_to be_nil
    end

    it 'rejects single slash' do
      message = base_message.dup
      message["cId"] = "/"
      expect(validate message, 'core', '3.3.0').not_to be_nil
    end
  end
end