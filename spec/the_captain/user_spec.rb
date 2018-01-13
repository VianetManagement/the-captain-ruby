# frozen_string_literal: true

require "spec_helper"

RSpec.describe "TheCaptain::User/s" do
  before { authenticate! }
  let(:ip_address)  { "206.181.8.242" }
  let(:user)        { 999_999_999_999_999 }
  let(:email)       { "user@example.com" }
  let(:credit_card) { "abc1234567" }
  let(:content)     { "Hello World!" }

  describe ".call" do
    context "Success" do
      it "should return information about a given user" do
        results = TheCaptain::User.call(user)
        expect(results.status).to eq(200)
        expect(results.value).to eq(user)
      end

      it "should return all users that have a matching ip" do
        results = TheCaptain::Users.call(ip_address: ip_address)
        expect(results.status).to eq(200)
        expect(results.ip_address).to_not be_nil
        expect(results.ip_address.users).to_not be_nil
      end
    end

    context "failure" do
      it "should fail if a content type is blank" do
        expect { TheCaptain::User.call("") }.to raise_exception(TheCaptain::Error::APIError)
      end

      it "should fail if content type is missing" do
        expect { TheCaptain::Users.call }.to raise_exception(TheCaptain::Error::APIError)
      end
    end
  end
end
