# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  RSpec.describe EmailAddress, :auto_auth do
    it { is_expected.to be_a_kind_of(APIResource) }

    describe ".api_paths" do
      subject { described_class.api_paths }

      it { is_expected.to be_frozen }
      its([:base])            { is_expected.to eq("email_addresses/%<resource_id>s") }
      its([:lists])           { is_expected.to eq("email_addresses/%<resource_id>s/related/lists") }
      its([:payments])        { is_expected.to eq("email_addresses/%<resource_id>s/related/payments") }
      its([:content])         { is_expected.to eq("email_addresses/%<resource_id>s/related/content") }
      its([:credit_cards])    { is_expected.to eq("email_addresses/%<resource_id>s/related/credit_cards") }
    end

    it_behaves_like "it has request methods"
  end
end
