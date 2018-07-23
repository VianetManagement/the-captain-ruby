# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  module Utility
    RSpec.describe Validation do
      let(:klass) { "ClassName" }

      shared_examples_for "Validation Success and Failure" do
        context "Success" do
          let(:params) { success_params }
          it { expect { subject }.to_not raise_error }
        end

        context "Failure" do
          let(:params) { failure_params }
          it { expect { subject }.to raise_error TheCaptain::Error::ClientError }
        end
      end

      describe ".contains_required_stats?" do
        described_class::REQUIRED_STATS_TYPE.each do |valid_type|
          context "state_type: #{valid_type}" do
            it_behaves_like "Validation Success and Failure" do
              let(:success_params) { { stats_type: valid_type, value: "success-since-I'm-defined" } }
              let(:failure_params) { { stats_type: valid_type } }
              subject { described_class.contains_required_stats?(klass, params) }
            end
          end
        end
      end

      describe ".contains_required_user?" do
        described_class::REQUIRED_USER.each do |valid_user_key|
          context valid_user_key.to_s do
            it_behaves_like "Validation Success and Failure" do
              let(:success_params) { { valid_user_key => "I'm valid since I'm defined with the correct key" } }
              let(:failure_params) { { fake_user_id: "abc123" } }
              subject { described_class.contains_required_user?(klass, params) }
            end
          end
        end
      end

      describe ".contains_required_content?" do
        described_class::REQUIRED_CONTENT.each do |valid_content_key|
          context valid_content_key.to_s do
            it_behaves_like "Validation Success and Failure" do
              let(:success_params) { { valid_content_key => "I'm valid since I'm defined with the correct key" } }
              let(:failure_params) { { fake_content_param: "abc123" } }
              subject { described_class.contains_required_content?(klass, params) }
            end
          end
        end
      end

      describe ".valid_content_parameter?" do
        context "Success" do
          it "should allow a string parameter without raising an error" do
            expect { described_class.valid_content_parameter?(klass, content: "sample content") }.to_not raise_error
          end

          it "should allow an array of string contents that do not exceed 10 elements in length" do
            params = { content: ("a".."j").to_a }
            expect { described_class.valid_content_parameter?(klass, params) }.to_not raise_error
          end
        end

        context "Failure" do
          it "should not allow non-strings to be passed in" do
            expect do
              described_class.valid_content_parameter?(klass, content: 123)
            end.to raise_error TheCaptain::Error::ClientError
          end

          it "should not allow arrays full of non-strings" do
            params = { content: (1..5).to_a }
            expect do
              described_class.valid_content_parameter?(klass, params)
            end.to raise_error TheCaptain::Error::ClientError
          end

          it "should not allow arrays mixed with strings and non-strings" do
            params = { content: ["abc", 123, "xyz"] }
            expect do
              described_class.valid_content_parameter?(klass, params)
            end.to raise_error TheCaptain::Error::ClientError
          end

          it "should not allow array's larger than 10 elements in size" do
            params = { content: ("a".."z").to_a }
            expect do
              described_class.valid_content_parameter?(klass, params)
            end.to raise_error TheCaptain::Error::ClientError
          end
        end
      end
    end
  end
end
