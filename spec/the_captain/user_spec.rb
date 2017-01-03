require "spec_helper"

module TheCaptain
  RSpec.describe "User" do
    before { authenticate! }

    describe ".merge_options" do
      let(:user) { build(:user) }
      let!(:ip_event) { IpAddress::EVENT_OPTIONS[user.ip_address.event] }
      let!(:content_event) { Content::EVENT_OPTIONS[user.content.event] }
      let!(:credit_card_event) { CreditCard::EVENT_OPTIONS[user.credit_card.event] }

      subject(:merge_options) { User.merge_options(user) }

      it "should call each options build class" do
        expect(IpAddress).to receive(:merge_options).with(user.ip_address).once
        expect(EmailAddress).to receive(:merge_options).with(user.email_address).once
        expect(CreditCard).to receive(:merge_options).with(user.credit_card).once
        expect(Content).to receive(:merge_options).with(user.content).once
        merge_options
      end

      it "should resolve each event type" do
        options = merge_options
        expect(options.ip_address.event).to eq(ip_event)
        expect(options.credit_card.event).to eq(credit_card_event)
        expect(options.content.event).to eq(content_event)
      end
    end

    describe ".submit" do
      context "validation" do
        let(:user) { build(:user) }
        before { allow(::TheCaptain).to receive(:request).and_return(true) }
        subject(:user_submission) { User.submit(user) }

        it { is_expected.to be_truthy }

        it "should rise an exception if no uid is found" do
          user.delete(:value)
          expect { user_submission }.to raise_error(ArgumentError, "value identifier required")
        end
      end
    end

    describe ".retrieve" do
      let(:user) { build(:user, value: 22) }
      before { allow(::TheCaptain).to receive(:request).and_return(true) }

      it " allows user to be a hashed value" do
        expect(User.retrieve(user)).to be_truthy
      end

      it " allows user to be a set variable" do
        user.delete(:value)
        expect(User.retrieve(22, user)).to be_truthy
      end

      it "should raise an error if no ID is found" do
        user.delete(:value)
        expect { User.retrieve(user) }.to raise_error(ArgumentError, "value identifier required")
      end
    end
  end
end
