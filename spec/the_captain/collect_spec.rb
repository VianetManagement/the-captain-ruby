# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  RSpec.describe Collect, :auto_auth do
    it { is_expected.to be_a_kind_of(APIResource) }

    describe ".api_paths" do
      subject { described_class.api_paths }

      it { is_expected.to be_frozen }
      its([:base]) { is_expected.to eq("collect") }
    end

    describe ".submit" do
      it_behaves_like "it succeeds and fails" do
        subject { described_class.submit(params) }

        let(:verb_method) { :post }
      end
    end
  end
end
