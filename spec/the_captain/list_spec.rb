require "spec_helper"

RSpec.describe TheCaptain::List do
  subject { described_class }
  before { authenticate! }
  let(:ip_address)  { "206.181.8.242" }
  let(:user)        { 999_999_999_999_999 }
  let(:email)       { "user@example.com" }
  let(:credit_card) { "abc1234567" }
  let(:content)     { "Hello World!" }
  let(:list_name)   { "Testing List" }
  let(:list_items) { ["abc", "123"] }

  describe ".data" do
    it "should submit a new list" do
      results = subject.data(value: list_name, items: list_items)
      expect(results.status).to eq(200)
    end
  end

  describe ".remove_list" do
    before { subject.data(value: list_name, items: list_items) }

    it "should remove the list" do
      results = subject.remove_list(list_name)
      expect(results.status).to eq(200)

      results = subject.call(list_name)
      expect(results.list.keys.empty?).to be_truthy
    end
  end

  describe ".call" do
    context "Success" do
      before { subject.data(value: list_name, items: list_items) }
      after { subject.remove_list(list_name) }

      it "should return information about a given user" do
        results = subject.call(list_name)
        expect(results.status).to eq(200)
        expect(results.list).to_not be_nil
      end
    end

    context "failure" do
      it "should fail if items are missing" do
        expect { subject.data(value: list_name) }.to raise_exception(TheCaptain::APIError)
        expect { subject.remove_item(value: list_name) }.to raise_exception(TheCaptain::APIError)
      end

      it "should fail if list name is missing" do
        expect { subject.data(items: list_items) }.to raise_exception(TheCaptain::APIError)
        expect { subject.remove_item(items: list_items) }.to raise_exception(TheCaptain::APIError)
      end
    end
  end
end
