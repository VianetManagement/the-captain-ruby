# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  RSpec.describe User, :auto_auth do
    describe ".api_paths" do
      subject { described_class.api_paths }
      its([:base])         { is_expected.to eq("/user") }
      its([:action])       { is_expected.to eq("/user/action") }
      its([:stats])        { is_expected.to eq("/user/stats") }
      its([:usage])        { is_expected.to eq("/user/usage") }
      its([:verification]) { is_expected.to eq("/user/verification") }
    end

    shared_examples_for "it succeeds and fails" do
      before { mock_http_request!(verb_method, payload: payload, status_code: status_code) }

      context "Success" do
        let(:status_code) { 200 }
        it { is_expected.to be_an_instance_of(Response::CaptainVessel).and(be_valid) }
      end

      context "Failure" do
        let(:status_code) { 400 }
        it { is_expected.to be_an_instance_of(Response::CaptainVessel).and(be_invalid) }
      end
    end

    context "Request Methods" do
      describe ".retrieve" do
        it_behaves_like "it succeeds and fails" do
          let(:params)      { { user: "abc123" } }
          let(:payload)     { { user: "test" } }
          let(:verb_method) { :get }
          subject { described_class.retrieve(params) }
        end
      end

      describe ".submit" do
        it_behaves_like "it succeeds and fails" do
          let(:params)      { { user: "abc123" } }
          let(:payload)     { { user: "test" } }
          let(:verb_method) { :post }
          subject { described_class.submit(params) }
        end
      end

      describe ".submit_action" do
        it_behaves_like "it succeeds and fails" do
          let(:params)      { { user: "abc123" } }
          let(:payload)     { { user: "test" } }
          let(:verb_method) { :post }
          subject { described_class.submit_action(params) }
        end
      end

      describe ".submit_verification" do
        it_behaves_like "it succeeds and fails" do
          let(:params)      { { user: "abc123" } }
          let(:payload)     { { user: "test" } }
          let(:verb_method) { :post }
          subject { described_class.submit_verification(params) }
        end
      end

      describe ".retrieve_verification" do
        it_behaves_like "it succeeds and fails" do
          let(:params)      { { user: "abc123" } }
          let(:payload)     { { user: "test" } }
          let(:verb_method) { :get }
          subject { described_class.retrieve_verification(params) }
        end
      end

      describe ".retrieve_usage" do
        it_behaves_like "it succeeds and fails" do
          let(:params)      { { user: "abc123" } }
          let(:payload)     { { user: "test" } }
          let(:verb_method) { :get }
          subject { described_class.retrieve_usage(params) }
        end
      end
    end

    describe ".validate_params!/1" do
      context "Success" do
        TheCaptain::Utility::Validation::REQUIRED_USER.each do |valid_param|
          it "Should accept a param with #{valid_param} as a key" do
            expect { described_class.validate_params!(valid_param => true) }.to_not raise_error
          end
        end
      end

      context "Failure" do
        it "Should fail if non of the required fields are present" do
          expect { described_class.validate_params!(faker: true) }.to raise_error TheCaptain::Error::ClientError
        end
      end
    end
  end
end
