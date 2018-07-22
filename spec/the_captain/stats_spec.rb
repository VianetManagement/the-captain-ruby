# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  RSpec.describe Stats, :auto_auth do
    it { is_expected.to be_a_kind_of(APIResource) }

    describe ".api_paths" do
      subject { described_class.api_paths }
      it { is_expected.to eq(base: "/stats") }
    end

    context "Request Methods" do
      let!(:verb_method) { :get }

      describe ".retrieve_ip_address" do
        it_behaves_like "it succeeds and fails" do
          subject { described_class.retrieve_ip_address("127.0.0.1", params) }
        end
      end

      describe ".retrieve_user" do
        it_behaves_like "it succeeds and fails" do
          subject { described_class.retrieve_user("user-123", params) }
        end
      end

      describe ".retrieve_content" do
        it_behaves_like "it succeeds and fails" do
          subject { described_class.retrieve_content("Hello World!", params) }
        end
      end

      describe ".retrieve_email_address" do
        it_behaves_like "it succeeds and fails" do
          subject { described_class.retrieve_email_address("user@example.com", params) }
        end
      end
    end

    describe ".merge_params!" do
      it "appends the `stats_type` and `value` key values to the request params" do
        params = {}
        described_class.merge_params!(:ip_address, "127.0.0.1", params)
        expect(params).to eq(stats_type: :ip_address, value: "127.0.0.1")
      end

      it "Removes stringified keys of `stats_type` and `value` in favor of symbols" do
        params = { "stats_type" => "random-type", "value" => "127.0.0.1" }
        described_class.merge_params!(:ip_address, "127.0.0.1", params)
        expect(params).to eq(stats_type: :ip_address, value: "127.0.0.1")
      end
    end
  end
end
