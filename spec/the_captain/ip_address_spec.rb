require "spec_helper"

RSpec.describe "IpAddress", :vcr do
  before { authenticate! }
  let!(:core_identifiers) { ["1.1.1.1", "1.1.1.2"] }
  let!(:users) { [88, 77] }

  describe ".submit" do
    %i(88 77).each do |id|
      it "Should return a status success for user: #{id}" do
        response = TheCaptain::IpAddress.submit(core_identifiers.first, user: id, event: :signup)
        expect(response.status).to eq(200)
      end
    end

    it "should accept adding an existing user to a new ip" do
      response = TheCaptain::IpAddress.submit(core_identifiers.last, user: users.last, event: :visit)
      expect(response.status).to eq(200)
    end
  end

  describe ".retrieve" do
    context "IP only" do
      it "should return an the most recently used IP submission" do
        response = TheCaptain::IpAddress.retrieve(core_identifiers.first)
        expect(response.status).to eq(200)
        expect(response.ip_address.first.user_id).to eq(users.last.to_s)
      end

      it "should return an array of users with pagination per" do
        response = TheCaptain::IpAddress.retrieve(core_identifiers.first, per: 5)
        expect(response.ip_address.count).to eq(5)
      end

      it "should return the second page of items" do
        response_old = TheCaptain::IpAddress.retrieve(core_identifiers.first, per: 5)
        response_new = TheCaptain::IpAddress.retrieve(core_identifiers.first, per: 5, page: 5)

        expect(response_old.ip_address.count).to eq(5)
        expect(response_new.ip_address.count).to eq(5)
        expect(response_old.ip_address.last.user_id != response_new.ip_address.last.user_id).to eq(true)
      end

      it "should return an array of users who have visited" do
        response = TheCaptain::IpAddress.retrieve(core_identifiers.last, event: :visit)
        expect(response.status).to eq(200)

        expect(response.ip_address.count).to eq(1)
        expect(response.ip_address.first.user_id).to eq(users.last.to_s)
        expect(response.ip_address.first.event).to eq("visit")
      end
    end

    context "IP and user" do
      it "should return specific information about an ip" do
        response = TheCaptain::IpAddress.retrieve(core_identifiers.first, user: users.first)
        expect(response.status).to eq(200)

        expect(response.ip_address.first.value).to be_present
        expect(response.ip_address.first.is_high_risk).to_not be_nil
        expect(response.ip_address.first.risk_score).to_not be_nil
        expect(response.ip_address.first.event).to_not be_nil
      end
    end
  end
end
