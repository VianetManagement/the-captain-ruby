# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  RSpec.describe User, :auto_auth do
    it { is_expected.to be_a_kind_of(APIResource) }

    describe ".api_paths" do
      subject { described_class.api_paths }

      it { is_expected.to be_frozen }
      its([:base])            { is_expected.to eq("/users/%<resource_id>s") }
      its([:payments])        { is_expected.to eq("/users/%<resource_id>s/related/payments") }
      its([:content])         { is_expected.to eq("/users/%<resource_id>s/related/content") }
      its([:ip_addresses])    { is_expected.to eq("/users/%<resource_id>s/related/ip_addresses") }
      its([:credit_cards])    { is_expected.to eq("/users/%<resource_id>s/related/credit_cards") }
      its([:email_addresses]) { is_expected.to eq("/users/%<resource_id>s/related/email_addresses") }
    end

    context "Request Methods" do
      let(:resource_id) { "apples-to-oranges" }

      describe ".receive" do
        it_behaves_like "it succeeds and fails" do
          subject { described_class.receive(resource_id, params) }
        end
      end

      %i[payments content ip_addresses credit_cards email_addresses].each do |method|
        describe ".related_#{method}" do
          it_behaves_like "it succeeds and fails" do
            subject { described_class.send("related_#{method}".to_sym, resource_id, params) }
          end
        end
      end
    end
  end
end
