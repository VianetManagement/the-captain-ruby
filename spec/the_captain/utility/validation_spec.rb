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
    end
  end
end
