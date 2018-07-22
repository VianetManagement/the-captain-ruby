# frozen_string_literal: true

require "spec_helper"

shared_examples_for "it succeeds and fails" do
  let(:params)      { { user: "abc123" } }
  let(:payload)     { { user: "test" } }

  before { mock_http_request!(verb_method, payload: payload, status_code: status_code) }
  before { expect(described_class).to receive(:validate_params!).and_call_original }

  context "Success" do
    let(:status_code) { 200 }
    it { is_expected.to be_an_instance_of(TheCaptain::Response::CaptainVessel).and(be_valid) }
  end

  context "Failure" do
    let(:status_code) { 400 }
    it { is_expected.to be_an_instance_of(TheCaptain::Response::CaptainVessel).and(be_invalid) }
  end
end
