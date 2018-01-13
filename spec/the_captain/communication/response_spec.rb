# frozen_string_literal: true

require "spec_helper"

RSpec.describe "TheCaptain::Communication::Response" do
  before { authenticate! }


  describe ".handle_api_error" do
    subject { TheCaptain.handle_api_error(response) }
    let(:response) { double("JSON", body: "My Input", status: status, errors: "This is an error") }

    context "success" do
      (200..204).each do |stat|
        let(:status) { stat }

        it "Should return the response back for #{stat} status" do
          is_expected.to eq(response)
        end
      end
    end

    context "Invalid Request" do
      let(:status) { 400 }

      it "raises an error" do
        expect { subject }.to raise_error(TheCaptain::Error::InvalidRequestError, response.errors)
      end
    end

    context "Authentication Error" do
      let(:status) { 401 }

      it "raises an error" do
        expect { subject }.to raise_error(TheCaptain::Error::AuthenticationError, response.errors)
      end
    end

    context "Not found Error" do
      let(:status) { 404 }

      it "raises an error" do
        expect { subject }.to raise_error(TheCaptain::Error::InvalidRequestError, response.errors)
      end
    end

    context "Internal Server Error" do
      let(:status) { 500 }

      it "raises an error" do
        expect { subject }.to raise_error(TheCaptain::Error::APIError, response.errors)
      end
    end

    context "Connection Error" do
      let(:status) { 502 }

      it "raises an error" do
        expect { subject }.to raise_error(TheCaptain::Error::APIConnectionError, response.errors)
      end
    end

    context "Catch all error" do
      let(:status) { (500..700).to_a.sample }

      it "raises an error" do
        expect { subject }.to raise_error(TheCaptain::Error::StandardException, response.errors)
      end
    end
  end
end
