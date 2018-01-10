# frozen_string_literal: true

require "spec_helper"

RSpec.describe "TheCaptain::Event" do
  before { authenticate! }
  let(:ip_address)  { "206.181.8.242" }
  let(:user)        { 999_999_999_999_999 }
  let(:email)       { "user@example.com" }
  let(:credit_card) { "abc1234567" }
  let(:content)     { "Hello World!" }

  describe ".call" do
    context "Success" do
      it "can return information about an ip address" do
        results = TheCaptain::Event.call(ip_address: ip_address)
        expect(results.status).to eq(200)
        expect(results.ip_address).to_not be_nil
        expect(results.ip_address.events).to_not be_nil
      end

      it "can return information about a email address " do
        results = TheCaptain::Event.call(email_address: email)
        expect(results.status).to eq(200)
        expect(results.email_address).to_not be_nil
        expect(results.email_address.events).to_not be_nil
      end

      it "can return information about a content peace " do
        results = TheCaptain::Event.call(content: content)
        expect(results.status).to eq(200)
        expect(results.content).to_not be_nil
        expect(results.content.events).to_not be_nil
      end

      it "can return information about a credit card " do
        results = TheCaptain::Event.call(credit_card: credit_card)
        expect(results.status).to eq(200)
        expect(results.credit_card).to_not be_nil
        expect(results.credit_card.events).to_not be_nil
      end
    end

    context "failure" do
      it "should raise an error if none of the required parameters are present" do
        expect { TheCaptain::Event.call }.to raise_exception(TheCaptain::APIError)
      end
    end
  end
end
