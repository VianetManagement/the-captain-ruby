# frozen_string_literal: true

require "spec_helper"

describe TheCaptain do
  let(:user) { 999_999_999_999_999 }

  describe ".enabled" do
    context "disabled" do
      it "Should return a hashed error stating it is disabled" do
        allow(TheCaptain).to receive(:enabled?).and_return(false)
        results = TheCaptain::User.call(user)
        expect(results.disabled).to be_truthy
      end
    end
  end

  describe "#AuthenticationError" do
    it "Should raise an exception if no API key is provided" do
      allow(TheCaptain).to receive(:api_key).and_return(nil)
      expect(TheCaptain::AuthenticationError).to receive(:no_key_provided).and_call_original
      expect { TheCaptain::User.call(user) }.to raise_error(StandardError)
    end

    it "Should raise an exception if an invalid key is provided" do
      allow(TheCaptain).to receive(:api_key).and_return(12_345)
      expect(TheCaptain::AuthenticationError).to receive(:invalid_key_provided).and_call_original
      expect { TheCaptain::User.call(user) }.to raise_error(StandardError)
    end
  end
end
