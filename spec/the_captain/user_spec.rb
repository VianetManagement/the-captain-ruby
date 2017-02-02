require "spec_helper"

module TheCaptain
  RSpec.describe "User" do
    before { authenticate! }

    describe ".merge_options" do
      let(:user) { build(:user, :global_event, event: :import_pick) }
      let(:event_results) { "import:pick" }

      subject(:merge_options) { User.merge_options(user) }

      it "should resolve each event type" do
        options = merge_options
        expect(options.ip_address.event).to eq(event_results)
        expect(options.credit_card.event).to eq(event_results)
        expect(options.content.event).to eq(event_results)
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
