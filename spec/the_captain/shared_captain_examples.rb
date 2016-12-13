require "spec_helper"

## Requires:
# let!(:captain_model) { TheCaptain::[Action] } => TheCaptain::Ip
# let!(:core_identifiers) { [main_value, secondary_value] } => ["127.0.0.1", "66.66.66.66"]
#
# Override:
# def check_profile_response(info, identifier, flags = [])

# Tip: Run `Event` specs first before retrieving. So you can VCR the response back

RSpec.shared_examples_for "it can request and send information" do
  before { authenticate! }

  describe "Event" do
    let(:flags) { [:high_risk, :one_bad_sob] }

    it "can create a new object with a flag" do
      info = captain_model.event(core_identifiers.first, user: 69, flag: flags.first)
      check_profile_response(info, core_identifiers.first, [flags.first])
    end

    it "can create multiple flags for a given object" do
      info = captain_model.event(core_identifiers.first, user: 69, flag: flags.last)
      check_profile_response(info, core_identifiers.first, flags)
    end

    it "can assign a user to multiple objects" do
      info = captain_model.event(core_identifiers.last, user: 69)
      expect(info.relationships.count).to eq(2)
      check_profile_response(info, core_identifiers.last)
    end
  end

  describe "retrieving" do
    it "can get information" do
      info = captain_model.retrieve(core_identifiers.first)
      check_profile_response(info, core_identifiers.first)
    end
  end
end
