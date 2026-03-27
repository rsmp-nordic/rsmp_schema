RSpec.describe "RSMP::Schema.status_catalogue" do
  {
    '1.0.7'  => 30,
    '1.0.8'  => 29,
    '1.0.9'  => 29,
    '1.0.10' => 29,
    '1.0.13' => 37,
    '1.0.14' => 41,
    '1.0.15' => 45,
    '1.1.0'  => 48,
    '1.2.0'  => 48,
    '1.2.1'  => 48
  }.each do |version, count|
    it "returns #{count} statuses for tlc #{version}" do
      catalogue = RSMP::Schema.status_catalogue(:tlc, version)
      expect(catalogue.size).to eq(count)
    end
  end
end
