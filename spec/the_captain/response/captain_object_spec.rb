# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  module Response
    RSpec.describe CaptainObject do
      it { is_expected.to be_a_kind_of(OpenStruct) }

      describe "#[method]? - check if hash key exists in table" do
        subject { described_class.new(should_be_true: "this exists") }
        its(:should_be_true?)  { is_expected.to be_truthy }
        its(:should_be_false?) { is_expected.to be_falsey }
      end
    end
  end
end
