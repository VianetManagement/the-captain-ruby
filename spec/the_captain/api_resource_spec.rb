# frozen_string_literal: true

require "spec_helper"
require "active_support/time"

describe TheCaptain::ApiResource do
  subject { described_class }

  let(:options) do
    {
      event: "hello_world",
      per: 1,
      page: 3,
      from: 1.hour.ago,
      to: 1.hour.from_now,
      items: "item1",
      user: 1,
    }
  end

  describe ".event_options" do
    it "should replace underscores with collins" do
      opts = subject.event_options(options)
      expect(opts[:event]).to eq("hello:world")
    end
  end

  describe ".pagination_options" do
    it "should replace pre and page with limit and skip" do
      opts = subject.pagination_options(options)
      expect(opts[:limit]).to eq(1)
      expect(opts[:skip]).to eq(3)
    end
  end

  describe ".user_id_options" do
    let(:user_record) { double("User", id: 99) }
    it "should return the variable itself if option is not an object" do
      opts = subject.user_id_options(options)
      expect(opts[:user_id]).to eq(1)
      expect(opts[:user]).to be_nil
    end

    it "should extract the id from the id field" do
      opts = subject.user_id_options(user: user_record)
      expect(opts[:user_id]).to eq(user_record.id)
      expect(opts[:user]).to be_nil
    end
  end

  describe ".items_options" do
    it "should convert single item to an array of items" do
      opts = subject.items_options(options)
      expect(opts[:items]).to match_array(["item1"])
    end

    it "shouldn't change anything if items is already an array" do
      opts = subject.items_options(items: ["item1"])
      expect(opts[:items]).to match_array(["item1"])
    end
  end
end
