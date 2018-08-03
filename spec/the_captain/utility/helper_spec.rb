# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  module Utility
    RSpec.describe Helper do
      describe ".normalize_path/2" do
        subject { described_class.normalize_path(api_path, resource_id) }

        context "Path contains resource_id reference" do
          let(:api_path)    { "/foo/%<resource_id>s/bar" }
          let(:resource_id) { "me" }
          it { is_expected.to eq("/foo/me/bar") }
        end

        context "Path does not contain a resource_id reference" do
          let(:api_path)    { "/foo/bar" }
          let(:resource_id) { "me" }
          it { is_expected.to eq("/foo/bar") }
        end

        context "No resource_id is provided" do
          let(:api_path)    { "/foo/%<resource_id>s/bar" }
          let(:resource_id) { nil }
          it { is_expected.to eq(api_path) }
        end
      end

      describe ".symbolize_names/1" do
        subject { described_class.symbolize_names(object) }

        context "Hash contains nested string keys" do
          let(:object) { { foo: { "bar" => "zoop" } } }
          its([:foo]) { is_expected.to eq(bar: "zoop").and(be_frozen) }
        end

        context "Hash contains an array of hashes with string keys" do
          let(:object) { { foo: [{ "bar" => "zip" }, { "bar" => "zoop" }] } }
          its([:foo])  { is_expected.to eq([{ bar: "zip" }, { bar: "zoop" }]).and(be_frozen) }
        end
      end
    end
  end
end
