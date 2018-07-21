# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  def self.reset
    @api_key           = nil
    @api_url           = nil
    @configuration     = nil
    @retry_attempts    = nil
    @raise_http_errors = nil
  end
end

RSpec.describe TheCaptain, manual_auth: true do
  subject { described_class }
  before  { described_class.reset }

  it "has a version number" do
    expect(subject::VERSION).not_to be nil
  end

  describe ".enabled?" do
    it "is enabled by default" do
      expect(subject.enabled?).to be_truthy
    end

    it "can be disabled" do
      described_class.enabled = false
      expect(subject.enabled?).to be_falsey
    end
  end

  describe ".configuration" do
    context "Defaults" do
      its(:api_key)            { is_expected.to be_empty }
      its(:api_url)            { is_expected.to_not be_empty }
      its(:retry_attempts)     { is_expected.to be_zero }
      its(:raise_http_errors?) { is_expected.to be_falsey }
    end

    context "Environmental Variables" do
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
