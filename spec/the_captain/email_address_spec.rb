require "spec_helper"

module TheCaptain
  RSpec.describe "EmailAddress" do
    before { authenticate! }

    describe ".submit" do
      before { allow(::TheCaptain).to receive(:request).and_return(true) }

      context "validation" do
        let(:email) { build(:email_address) }
        it "should return true for correct input" do
          expect(EmailAddress.submit(email.value, email)).to eq(true)
        end

        it "should rise an error if no UID is present" do
          email.delete(:user)
          expect do
            EmailAddress.submit(email.value, email)
          end.to raise_error(ArgumentError, "user or user_id is required")
        end
      end
    end

    describe ".delete" do
      let(:email) { build(:email_address) }

      it "should raise a No Method exception" do
        expect { EmailAddress.delete(email.value) }.to raise_exception(NoMethodError)
      end
    end
  end
end
