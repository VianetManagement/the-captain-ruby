require "spec_helper"

RSpec.describe TheCaptain::Lists do
  subject { described_class }

  describe ".retrieve" do
    before { expect(TheCaptain).to receive(:request).and_return(true) }

    it "should not raise a No Method exception" do
      expect(subject.retrieve).to eq(true)
    end
  end

  describe ".submit" do
    it "should raise a No Method exception" do
      expect { subject.submit }.to raise_exception(NoMethodError)
    end
  end

  describe ".delete" do
    it "should raise a No Method exception" do
      expect { subject.delete }.to raise_exception(NoMethodError)
    end
  end
end
