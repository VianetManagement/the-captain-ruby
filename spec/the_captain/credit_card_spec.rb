# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  RSpec.describe CreditCard, :auto_auth do
    it { is_expected.to be_a_kind_of(APIResource) }

    describe ".api_paths" do
      subject { described_class.api_paths }

      it { is_expected.to be_frozen }
      its([:base])            { is_expected.to eq("credit_cards/%<resource_id>s") }
      its([:lists])           { is_expected.to eq("credit_cards/%<resource_id>s/related/lists") }
      its([:payments])        { is_expected.to eq("credit_cards/%<resource_id>s/related/payments") }
      its([:content])         { is_expected.to eq("credit_cards/%<resource_id>s/related/content") }
      its([:email_addresses]) { is_expected.to eq("credit_cards/%<resource_id>s/related/email_addresses") }
      its([:ip_addresses])    { is_expected.to eq("credit_cards/%<resource_id>s/related/ip_addresses") }
    end

    it_behaves_like "it has request methods"
  end
end
