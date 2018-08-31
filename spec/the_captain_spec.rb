# frozen_string_literal: true

require "spec_helper"

RSpec.describe TheCaptain do
  subject { described_class }

  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  describe ".enabled?" do
    subject(:enabled?) { described_class }

    it "is enabled by default" do
      expect(enabled?).to be_enabled
    end

    it "can be disabled" do
      described_class.enabled = false
      expect(enabled?).not_to be_enabled
    end
  end

  describe ".configuration" do
    context "with Defaults" do
      its(:api_key)            { is_expected.to be_empty }
      its(:api_url)            { is_expected.not_to be_empty }
      its(:retry_attempts)     { is_expected.to be_zero }
      its(:raise_http_errors?) { is_expected.to be_falsey }
    end

    context "with Environmental Variables" do
      let(:api_key)     { "secret-key" }
      let(:api_url)     { "https://google.com/v5" }

      before do
        ENV["CAPTAIN_API_KEY"] = api_key
        ENV["CAPTAIN_API_URL"] = api_url
      end

      its(:api_key) { is_expected.to eq(api_key) }
      its(:api_url) { is_expected.to eq(api_url) }
    end
  end

  describe ".configure" do
    let(:api_key)     { "nxt-secret-key" }
    let(:api_url)     { "https://captain-url.com/v6" }

    before do
      described_class.configure do |config|
        config.api_key           = api_key
        config.api_url           = api_url
        config.retry_attempts    = 9
        config.raise_http_errors = true
      end
    end

    its(:api_key)            { is_expected.to eq(api_key) }
    its(:api_url)            { is_expected.to eq(api_url) }
    its(:retry_attempts)     { is_expected.to eq(9) }
    its(:raise_http_errors?) { is_expected.to be_truthy }
  end
end
