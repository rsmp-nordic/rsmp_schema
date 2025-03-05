RSpec.describe "Traffic Light Controller RSMP SXL Schema validation" do
  let(:message) {{
    "mType" => "rSMsg",
    "mId" => "4173c2c8-a933-43cb-9425-66d4613731ed",
    "type" => "StatusResponse",
    "cId" => "O+14439=481WA001",
    "sTs" => "2015-06-08T09:15:18.266Z",
     "sS" => [
       { "sCI" => "S0003", "n" => "inputstatus", "s" => "100101", "q" => "recent" }
     ]
  }}


  it 'accepts valid message' do
    expect(validate message, 'core').to be_nil
  end

  describe "q=recent" do 
    it 'rejects s=null if q=recent' do
      message["sS"].first["q"] = "recent"
      message["sS"].first["s"] = nil
      expect(validate message, 'core').to eq(
        ["3.1.2", "3.1.3", "3.1.4", "3.1.5"] => [["/sS/0/s", "string"]],
        ["3.2.0", "3.2.1", "3.2.2"] => [["/sS/0/s", "type"]],
      )
    end
  end

  describe "q=old" do
    it 'rejects s=null if q=old' do
      message["sS"].first["q"] = "old"
      message["sS"].first["s"] = nil
      expect(validate message, 'core').to eq(
        ["3.1.2", "3.1.3", "3.1.4", "3.1.5"] => [["/sS/0/s", "string"]],
        ["3.2.0", "3.2.1", "3.2.2"] => [["/sS/0/s", "type"]],
      )
    end
  end

  describe "q=undefined" do
    it 'is rejects before 3.1.3' do
      message["sS"].first["q"] = "undefined"
      expect(validate message, 'core', '<3.1.3').to eq([["/sS/0/q", "enum"]])
    end

    it 'requires s being null from 3.1.3' do
      message["sS"].first["q"] = "undefined"
      message["sS"].first["s"] = nil
      expect(validate message, 'core', '>=3.1.3').to be_nil
      message["sS"].first["s"] = "something"
      expect(validate message, 'core', '>=3.1.3').to eq([["/sS/0/s", "null"]])
    end
  end

  describe "q=unknown" do
    it 'rejects s being null before 3.1.3' do
      message["sS"].first["q"] = "unknown"
      message["sS"].first["s"] = nil
      expect(validate message, 'core', '<3.1.3').to eq(
        [["/sS/0/s", "string"]])
    end

    it 'requires s being null from 3.1.3' do
      message["sS"].first["q"] = "unknown"
      message["sS"].first["s"] = nil
      expect(validate message, 'core', '>=3.1.3').to be_nil
      message["sS"].first["s"] = "something"
      expect(validate message, 'core', '>=3.1.3').to eq([["/sS/0/s", "null"]])
    end
  end

  describe "argument check" do
    it 'rejects missing component id' do
      message.delete 'cId'
      expect(validate message, 'core').to eq(
        [["", "required", {"missing_keys"=>["cId"]}]]
      )
    end

    it 'rejects bad status code' do
      message['sS'].first['sCI'] = '99'
      expect(validate message, 'core').to eq(
        [["/sS/0/sCI", "pattern"]]
      )
    end

    it 'rejects empty sS array' do
      message['sS'].clear
      expect( validate(message, 'core') ).to eq(
        [["/sS", "minItems"]]
      )
    end

    it 'rejects bad sS type' do
      message['sS'] = {}
      expect( validate(message, 'core') ).to eq(
        [["/sS", "array"]]
      )
    end

    it 'rejects missing status code' do
      message['sS'].first.delete 'sCI'
      expect(validate message, 'core').to eq(
        [["/sS/0", "required", {"missing_keys"=>["sCI"]}]]
      )
    end

    it 'rejects bad status code' do
      message['sS'].first['sCI'] = 3
      expect(validate message, 'core').to eq(
        [["/sS/0/sCI", "string"]]
      )

      message['sS'].first['sCI'] = '3'
      expect(validate message, 'core').to eq(
        [["/sS/0/sCI", "pattern"]]
      )
    end

    it 'rejects missing name' do
      message['sS'].first.delete 'n'
      expect(validate message, 'core').to eq(
        [["/sS/0", "required", {"missing_keys"=>["n"]}]]
      )
    end

    it 'rejects bad name' do
      message['sS'].first['n'] = 3
      expect(validate message, 'core').to eq(
        [["/sS/0/n", "string"]]
      )
    end

    it 'rejects n being null' do
      message['sS'].first['n'] = nil
      expect(validate message, 'core').to eq([["/sS/0/n", "string"]])
    end


    it 'rejects missing value' do
      message['sS'].first.delete 's'
      expect(validate message, 'core').to eq(
        [["/sS/0", "required", {"missing_keys"=>["s"]}]]
      )
    end

    it 'rejects bad quality' do
      message['sS'].first['q'] = 'great'
      expect(validate message, 'core').to eq(
        [["/sS/0/q", "enum"]]
      )
    end
  end
end
