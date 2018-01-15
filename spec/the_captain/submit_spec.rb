# frozen_string_literal: true

require "spec_helper"

RSpec.describe TheCaptain::Submit do
  before { authenticate! }
  let(:ip_address)  { "206.181.8.242" }
  let(:user)        { 999_999_999_999_999 }
  let(:email)       { "user@example.com" }
  let(:credit_card) { "abc1234567" }
  let(:content)     { "Hello World!" }

  describe ".data" do
    context "Success" do
      it "will submit ip information to the captain" do
        results = TheCaptain::Submit.data(ip_address: ip_address, user: user, event: :test_event)
        expect(results.status).to eq(200)
        expect(results.ip_address).to_not be_nil
      end

      it "will submit content to the captain" do
        results = TheCaptain::Submit.data(content: content, user: user, event: :test_event)
        expect(results.status).to eq(200)
        expect(results.content).to_not be_nil
      end

      it "will submit email address to the captain" do
        results = TheCaptain::Submit.data(email_address: email, user: user, event: :test_event)
        expect(results.status).to eq(200)
        expect(results.email_address).to_not be_nil
      end

      it "will submit credit card to the captain" do
        results = TheCaptain::Submit.data(credit_card: credit_card, user: user, event: :test_event)
        expect(results.status).to eq(200)
        expect(results.credit_card).to_not be_nil
      end
    end

    context "failure" do
      it "should fail if a content type is missing" do
        expect { TheCaptain::Submit.data(user: user) }.to raise_exception(TheCaptain::Error::APIError)
      end

      it "should fail if a user/session id is missing" do
        expect { TheCaptain::Submit.data(ip_address: ip_address) }.to raise_exception(TheCaptain::Error::APIError)
      end
    end
  end
end
