require "spec_helper"

RSpec.describe TheCaptain::List do
  subject { described_class }
  before { expect(TheCaptain).to receive(:request).and_return(true) }

  describe ".retrieve" do
    it "should not raise a No Method exception" do
      expect(subject.retrieve("list name")).to eq(true)
    end
  end

  describe ".submit" do
    it "should not raise a No Method exception" do
      expect(subject.submit("list name", items: "random item")).to eq(true)
    end
  end

  describe ".delete" do
    it "should not raise a No Method exception" do
      expect(subject.delete("item name")).to eq(true)
    end
  end
end
