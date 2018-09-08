# frozen_string_literal: true

require "spec_helper"

shared_examples_for "it succeeds and fails" do
  let(:params)      { { user: "abc123" } }
  let(:payload)     { { user: "test" } }
  let(:verb_method) { :get }

  before { mock_http_request!(verb_method, payload: payload, status_code: status_code) }

  context "when Success" do
    let(:status_code) { 200 }

    it { is_expected.to be_an_instance_of(TheCaptain::Response::CaptainVessel).and(be_valid) }
  end

  context "when Failure" do
    let(:status_code) { 400 }

    it { is_expected.to be_an_instance_of(TheCaptain::Response::CaptainVessel).and(be_invalid) }
  end
end

shared_examples_for "it has request methods" do
  let(:resource_id) { "apples-to-oranges" }

  describe ".receive" do
    it_behaves_like "it succeeds and fails" do
      subject { described_class.receive(resource_id, params) }
    end
  end

  described_class.api_paths.each_key do |method|
    next if method == :base
    describe ".related_#{method}" do
      it_behaves_like "it succeeds and fails" do
        subject { described_class.send("related_#{method}".to_sym, resource_id, params) }
      end
    end
  end
end
