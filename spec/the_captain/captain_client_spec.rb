# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  RSpec.describe CaptainClient, :auto_auth do
    describe ".default_conn" do
      context "Headers" do
        subject { described_class.default_conn.default_options.headers }
        its(["X-API-KEY"]) { is_expected.to eq("my-extra-secret-key") }
        its(["Accept"])    { is_expected.to eq("application/json") }
      end

      context "Timeout options" do
        subject { described_class.default_conn.default_options.timeout_options }
        its([:read_timeout])    { is_expected.to eq(5) }
        its([:write_timeout])   { is_expected.to eq(5) }
        its([:connect_timeout]) { is_expected.to eq(5) }
      end
    end

    describe ".default_client" do
      subject { described_class.default_client }
      before { expect(described_class).to receive(:new).with(described_class.default_conn).and_call_original }

      it { is_expected.to be_an_instance_of(described_class) }

      it "Should assign the client to the given thread" do
        expect { subject }.to change { Thread.current[:captain_default_client] }.to(be_an_instance_of(described_class))
      end
    end

    describe "#request" do
      subject(:request) { described_class.default_client.request(verb, "/ip_address", {}) }
      let(:verb)        { :get }

      context "Request Verb Methods" do
        subject { request.response }
        before  { mock_http_request!(verb) }

        context "GET" do
          let(:verb)   { :get }
          its(:body)   { is_expected.to eq("\"get_request\"") }
          its(:status) { is_expected.to be_success }
        end

        context "POST" do
          let(:verb)   { :post }
          its(:body)   { is_expected.to eq("\"post_request\"") }
          its(:status) { is_expected.to be_success }
        end

        context "PATCH" do
          let(:verb)   { :patch }
          its(:body)   { is_expected.to eq("\"patch_request\"") }
          its(:status) { is_expected.to be_success }
        end
      end

      describe "Raising Exceptions" do
        context "TheCaptain.raise_http_errors? is truthful" do
          before { allow(TheCaptain).to receive(:raise_http_errors?).and_return(true) }

          it "Should raise an API Auth error when status code is 401" do
            mock_client_get!(status_code: 401)
            expect { subject }.to raise_error Error::APIAuthorizationError
          end

          it "Should raise an API Connection error when status code is between 500 & 502" do
            mock_client_get!(status_code: [500, 501, 502].sample)
            expect { subject }.to raise_error Error::APIConnectionError
          end
        end

        context "TheCaptain.raise_http_errors? is false" do
          before do
            allow(TheCaptain).to receive(:raise_http_errors?).and_return(false)
            mock_client_get!(status_code: 401)
          end

          it "Should not raise any exceptions based on a bad status" do
            expect { subject }.to_not raise_error
          end
        end
      end

      context "Validation Errors" do
        let(:verb) { :put }

        it "Should raise an error when a api key empty" do
          reset_configurations!
          expect { subject }.to raise_error Error::ClientAuthenticationError
        end

        it "Should raise an error if its not a whitelisted request method" do
          expect { subject }.to raise_error Error::ClientInvalidRequestError
        end
      end
    end

    describe "#decode_response" do
      subject { described_class.active_client.decode_response }

      context "After a request is made" do
        let(:payload) { http_response(payload: { hello: "world" }.to_json) }
        before { described_class.active_client.instance_variable_set(:@response, payload) }

        it { is_expected.to be_an_instance_of(Response::CaptainVessel) }
      end

      context "No Requests have been made" do
        it "raises an error" do
          expect { subject }.to raise_error Error::ClientError
        end
      end
    end
  end
end
