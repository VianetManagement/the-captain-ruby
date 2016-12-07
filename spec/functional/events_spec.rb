require File.expand_path("../../spec_helper", __FILE__)

RSpec.describe "Events" do
  describe "Create an event", :vcr do
    before { authenticate! }

    it "can create an event" do
      response = TheCaptain::Event.create("user.signup", user_id: "foo_bar_1",
                                                         session_id: "234jasdfjio34234",
                                                         ip_address: Faker::Internet.ip_v4_address,
                                                         user_email: Faker::Internet.email,
                                                         name: Faker::Name.name,
                                                         phone: Faker::PhoneNumber.phone_number.delete("."))

      expect(response.status).to eq(201)
      expect(response.body.length).to eq(0)
    end
  end

  describe "Querying events", :vcr do
    before { authenticate! }

    context "before" do
      before { Timecop.freeze(Time.local(2016, 1, 1)) }
      after { Timecop.return }

      it "can query events before a specified time" do
        response = TheCaptain::Event.query(event_name: "user.signup", before: Time.now.to_i)

        expect(response.status).to eq(200)
        expect(response).to respond_to(:events)
        expect(response.events.count).to be > 1
        expect(response.links[:first]).to be_present
        expect(response.links[:last]).to be_present
        expect(response.links[:self]).to be_present
      end
    end

    context "after" do
      before { Timecop.freeze(Time.local(2015, 12, 1)) }
      after { Timecop.return }

      it "can query events after a specific time" do
        response = TheCaptain::Event.query(event_name: "user.signup", after: Time.now.to_i)

        expect(response.status).to eq(200)
        expect(response).to respond_to(:events)
        expect(response.events.count).to be > 1
        expect(response.links[:first]).to be_present
        expect(response.links[:last]).to be_present
        expect(response.links[:self]).to be_present
      end
    end

    context "between" do
      before { Timecop.freeze(Time.local(2015, 12, 1)) }
      after { Timecop.return }

      it "can query events between 2 times" do
        response = TheCaptain::Event.query(
          event_name: "user.signup",
          after: Time.now.to_i,
          before: Time.local(2016, 1, 1).to_i,
        )

        expect(response.status).to eq(200)
        expect(response).to respond_to(:events)
        expect(response.events.count).to be > 1
        expect(response.links[:first]).to be_present
        expect(response.links[:last]).to be_present
        expect(response.links[:self]).to be_present
      end
    end

    it "can query events that have a property that equals a given value" do
      response = TheCaptain::Event.query(event_name: "user.signup", filters: [
                                           { property: "user_id", operator: "eq", value: "foo_bar_1" },
                                         ])

      expect(response.status).to eq(200)
      expect(response).to respond_to(:events)
      expect(response.events.count).to be > 1
      expect(response.links[:first]).to be_present
      expect(response.links[:last]).to be_present
      expect(response.links[:self]).to be_present
    end

    it "can query events that have a property that does not equal a given value" do
      response = TheCaptain::Event.query(event_name: "user.signup", filters: [
                                           { property: "user_id", operator: "ne", value: "foo_bar_1" },
                                         ])

      expect(response.status).to eq(200)
      expect(response).to respond_to(:events)
      expect(response.events.count).to be > 1
      expect(response.links[:first]).to be_present
      expect(response.links[:last]).to be_present
      expect(response.links[:self]).to be_present
    end

    it "can query events by user_id" do
      response = TheCaptain::Event.query(event_name: "user.signup", user_id: "foo_bar_1")

      expect(response.status).to eq(200)
      expect(response).to respond_to(:events)
      expect(response.events.count).to be > 1
      expect(response.links[:first]).to be_present
      expect(response.links[:last]).to be_present
      expect(response.links[:self]).to be_present
    end
  end

  describe "Counting events", :vcr do
    before { authenticate! }

    context "before" do
      before { Timecop.freeze(Time.local(2016, 1, 1)) }
      after { Timecop.return }

      it "can count events before a specified time" do
        response = TheCaptain::Event.count(event_name: "user.signup", before: Time.now.to_i)

        expect(response.status).to eq(200)
        expect(response.result).to be > 1
      end
    end

    context "after" do
      before { Timecop.freeze(Time.local(2015, 12, 1)) }
      after { Timecop.return }

      it "can count events after a specific time" do
        response = TheCaptain::Event.count(event_name: "user.signup", after: Time.now.to_i)

        expect(response.status).to eq(200)
        expect(response.result).to be > 1
      end
    end

    context "between" do
      before { Timecop.freeze(Time.local(2015, 12, 1)) }
      after { Timecop.return }

      it "can count events between 2 times" do
        response = TheCaptain::Event.count(
          event_name: "user.signup",
          after: Time.now.to_i,
          before: Time.local(2016, 1, 1).to_i,
        )

        expect(response.status).to eq(200)
        expect(response.result).to be > 1
      end
    end

    it "can count events that have a property that equals a given value" do
      response = TheCaptain::Event.count(event_name: "user.signup", filters: [
                                           { property: "user_id", operator: "eq", value: "foo_bar_1" },
                                         ])

      expect(response.status).to eq(200)
      expect(response.result).to be > 1
    end

    it "can count events that have a property that does not equal a given value" do
      response = TheCaptain::Event.count(event_name: "user.signup", filters: [
                                           { property: "user_id", operator: "ne", value: "foo_bar_1" },
                                         ])

      expect(response.status).to eq(200)
      expect(response.result).to be > 1
    end

    it "can count events by user_id" do
      response = TheCaptain::Event.count(event_name: "user.signup", user_id: "foo_bar_1")

      expect(response.status).to eq(200)
      expect(response.result).to be > 1
    end
  end
end
