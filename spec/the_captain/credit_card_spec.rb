require "spec_helper"

RSpec.describe "CreditCard", :vcr do
  before { authenticate! }
  let!(:core_identifiers) { ["SUDA_FINGER", "KINDA_FINGER"] }
  let!(:users) { [88, 77] }

  describe ".submit" do
    %i(88 77).each do |id|
      it "Should return a status success for user: #{id}" do
        response = TheCaptain::CreditCard.submit(core_identifiers.first, user: id, event: :success)
        expect(response.status).to eq(200)
      end
    end

    it "should accept adding an existing user to a new credit card" do
      response = TheCaptain::CreditCard.submit(core_identifiers.last, user: users.last, event: :failed)
      expect(response.status).to eq(200)
    end
  end

  describe ".retrieve" do
    context "CreditCard only" do
      it "should return an the most recently used credit card submission" do
        response = TheCaptain::CreditCard.retrieve(core_identifiers.first)
        expect(response.status).to eq(200)
        expect(response.credit_card.first.user_id).to eq(users.last.to_s)
      end

      it "should return an array of users with pagination per" do
        response = TheCaptain::CreditCard.retrieve(core_identifiers.first, per: 1)
        expect(response.credit_card.count).to eq(1)
      end

      it "should return the second page of items" do
        response_old = TheCaptain::CreditCard.retrieve(core_identifiers.first, per: 1)
        response_new = TheCaptain::CreditCard.retrieve(core_identifiers.first, per: 1, page: 1)

        expect(response_old.credit_card.count).to eq(1)
        expect(response_new.credit_card.count).to eq(1)
        expect(response_old.credit_card.last.user_id != response_new.credit_card.last.user_id).to eq(true)
      end

      it "should return an array of users who have failed" do
        response = TheCaptain::CreditCard.retrieve(core_identifiers.last, event: :failed)
        expect(response.status).to eq(200)

        expect(response.credit_card.count).to eq(1)
        expect(response.credit_card.first.user_id).to eq(users.last.to_s)
        expect(response.credit_card.first.event).to eq(TheCaptain::CreditCard::EVENT_OPTIONS[:failed])
      end
    end

    context "Credit Card and user" do
      it "should return specific information about an ip" do
        response = TheCaptain::CreditCard.retrieve(core_identifiers.first, user: users.first)
        expect(response.status).to eq(200)

        expect(response.credit_card.first.value).to be_present
        expect(response.credit_card.first.event).to_not be_nil
        expect(response.credit_card.first.user_id).to eq(users.first.to_s)
      end
    end
  end
end
