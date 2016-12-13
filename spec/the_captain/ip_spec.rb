require "spec_helper"

RSpec.describe "Ip", :vcr do
  it_behaves_like "it can request and send information" do
    let!(:captain_model) { TheCaptain::Ip }
    let!(:core_identifiers) { ["216.234.107.132", "216.233.107.131"] }
  end

  def check_profile_response(info, ip_address, flags = [])
    expect(info.profile.value).to eq(ip_address)
    expect(info.profile.analytics).to_not be_nil
    expect(info.profile.analytics.location).to_not be_nil
    expect(info.profile.analytics.location.latitude).to_not be_nil
    expect(info.profile.analytics.location.longitude).to_not be_nil

    flags.each do |flag|
      expect(info.profile.flags).to include(flag.to_s)
    end
  end
end
