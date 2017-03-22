require "spec_helper"

RSpec.describe TheCaptain::Utility::Util do
  let(:hash_object) do
    {
      "name" => "George",
      "location" => { "city" => "Grand Rapids", "zip_code" => 49_512 },
      "maps" => [{ "x" => 2, "y" => 5 }, { "x" => 3, "y" => 3 }],
    }
  end

  describe ".symbolize_names" do
    context "Single Hash table" do
      it "should symbolize all names in the hash table" do
        result = subject.symbolize_names(hash_object)
        compare_hash_table(result)
      end
    end

    context "Array of hashes" do
      let(:array_of_hashes) { [hash_object, hash_object] }
      it "should symbolize all names in the hash table" do
        results = subject.symbolize_names(array_of_hashes)
        results.each { |result| compare_hash_table(result) }
      end
    end

    def compare_hash_table(result)
      expect(result[:name]).to eq(hash_object["name"])
      expect(result[:location][:city]).to eq(hash_object["location"]["city"])
      expect(result[:location][:zip_code]).to eq(hash_object["location"]["zip_code"])

      expect(result[:maps].first[:x]).to eq(hash_object["maps"].first["x"])
      expect(result[:maps].first[:y]).to eq(hash_object["maps"].first["y"])

      expect(result[:maps].last[:x]).to eq(hash_object["maps"].last["x"])
      expect(result[:maps].last[:x]).to eq(hash_object["maps"].last["y"])
    end
  end

  describe ".mashify" do
    it "should mashify the hashed table" do
      result = subject.mashify(hash_object)

      expect(result.name).to eq(hash_object["name"])
      expect(result.location.city).to eq(hash_object["location"]["city"])
      expect(result.location.zip_code).to eq(hash_object["location"]["zip_code"])

      expect(result.maps.first.x).to eq(hash_object["maps"].first["x"])
      expect(result.maps.first.y).to eq(hash_object["maps"].first["y"])

      expect(result.maps.last.x).to eq(hash_object["maps"].last["x"])
      expect(result.maps.last.y).to eq(hash_object["maps"].last["y"])
    end
  end
end
