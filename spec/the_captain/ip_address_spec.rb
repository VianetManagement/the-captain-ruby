require "spec_helper"

RSpec.describe "IpAddress", :vcr do
  before { authenticate! }
  let!(:core_identifiers) { ["1.1.1.1", "1.1.1.2"] }
  let!(:users) { [88, 77] }

  describe ".submit" do
    %i(88 77).each do |id|
      it "Should return a status success for user: #{id}" do
        response = TheCaptain::IpAddress.submit(core_identifiers.first, user: id, condition: :signup)
        expect(response.status).to eq(200)
      end
    end

    it "should accept adding an existing user to a new ip" do
      response = TheCaptain::IpAddress.submit(core_identifiers.last, user: users.last, condition: :visit)
      expect(response.status).to eq(200)
    end
  end

  describe ".retrieve" do
    context "IP only" do
      it "should return an array of users from a given ip" do
        response = TheCaptain::IpAddress.retrieve(core_identifiers.first)
        expect(response.status).to eq(200)
        expect(response.ip_address.count).to be > 1
      end

      it "should return an array of users who have visited" do
        response = TheCaptain::IpAddress.retrieve(core_identifiers.last, condition: :visit)
        expect(response.status).to eq(200)

        expect(response.ip_address.count).to eq(1)
        expect(response.ip_address.first.user_id).to eq(users.last.to_s)
      end
    end

    context "IP and user" do
      it "should return specific information about an ip" do
        response = TheCaptain::IpAddress.retrieve(core_identifiers.first, user: users.first)
        expect(response.status).to eq(200)

        expect(response.ip_address.first.value).to be_present
        expect(response.ip_address.first.is_high_risk).to_not be_nil
        expect(response.ip_address.first.risk_score).to_not be_nil
        expect(response.ip_address.first.condition).to_not be_nil
      end
    end
  end
end
