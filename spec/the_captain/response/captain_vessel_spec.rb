# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  module Response
    RSpec.describe CaptainVessel do
      let(:response)    { http_response(payload: { hello: "world" }, status_code: status_code) }
      let(:status_code) { 200 }

      subject { described_class.new(response) }

      describe ".new" do
        it { is_expected.to be_frozen }

        its(:data)         { is_expected.to be_an_instance_of(CaptainObject).and(be_frozen) }
        its(:raw_response) { is_expected.to be_an_instance_of(HTTP::Response) }
        its(:status)       { is_expected.to be_an_instance_of(HTTP::Response::Status) }

        it "raises an error when the initializing object isn't an HTTP::Response object" do
          expect { described_class.new(false) }.to raise_error Error::ClientInvalidResourceError
        end
      end

      describe "#valid?" do
        context "Good 2XX status code" do
          its(:valid?)   { is_expected.to be_truthy }
          its(:invalid?) { is_expected.to be_falsey }
        end

        context "Bad 4XX status code" do
          let(:status_code) { 400 }
          its(:valid?)      { is_expected.to be_falsey }
          its(:invalid?)    { is_expected.to be_truthy }
        end
      end
    end
  end
end
