# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  RSpec.describe User, :auto_auth do
    it { is_expected.to be_a_kind_of(APIResource) }

    describe ".api_paths" do
      subject { described_class.api_paths }
      its([:base])         { is_expected.to eq("/user") }
      its([:action])       { is_expected.to eq("/user/action") }
      its([:stats])        { is_expected.to eq("/user/stats") }
      its([:usage])        { is_expected.to eq("/user/usage") }
      its([:verification]) { is_expected.to eq("/user/verification") }
    end

    context "Request Methods" do
      describe ".retrieve" do
        it_behaves_like "it succeeds and fails" do
          let(:verb_method) { :get }
          subject { described_class.retrieve(params) }
        end
      end

      describe ".submit" do
        it_behaves_like "it succeeds and fails" do
          let(:verb_method) { :post }
          subject { described_class.submit(params) }
        end
      end

      describe ".submit_action" do
        it_behaves_like "it succeeds and fails" do
          let(:verb_method) { :post }
          subject { described_class.submit_action(params) }
        end
      end

      describe ".submit_verification" do
        it_behaves_like "it succeeds and fails" do
          let(:verb_method) { :post }
          subject { described_class.submit_verification(params) }
        end
      end

      describe ".retrieve_verification" do
        it_behaves_like "it succeeds and fails" do
          let(:verb_method) { :get }
          subject { described_class.retrieve_verification(params) }
        end
      end

      describe ".retrieve_usage" do
        it_behaves_like "it succeeds and fails" do
          let(:verb_method) { :get }
          subject { described_class.retrieve_usage(params) }
        end
      end
    end
  end
end
