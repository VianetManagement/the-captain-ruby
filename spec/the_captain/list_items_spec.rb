require "spec_helper"

RSpec.describe TheCaptain::ListItem do
  subject { described_class }

  describe ".retrieve" do
    it "should raise a No Method exception" do
      expect { subject.retrieve }.to raise_exception(NoMethodError)
    end
  end

  describe ".submit" do
    it "should raise a No Method exception" do
      expect { subject.submit }.to raise_exception(NoMethodError)
    end
  end

  describe ".delete" do
    before { expect(TheCaptain).to receive(:request).and_return(true) }

    it "should not raise a No Method exception" do
      expect(subject.delete("random", item: "random")).to eq(true)
    end
  end
end
