# frozen_string_literal: true

require "spec_helper"

module TheCaptain
  RSpec.describe CaptainClient, :auto_auth do
    describe ".default_conn" do
      context "with defined headers" do
        subject { described_class.default_conn.default_options.headers }

        its(["X-API-KEY"]) { is_expected.to eq("my-extra-secret-key") }
        its(["Accept"])    { is_expected.to eq("application/json") }
      end

      context "with default timeout options" do
        subject { described_class.default_conn.default_options.timeout_options }

        its([:read_timeout])    { is_expected.to eq(5) }
        its([:write_timeout])   { is_expected.to eq(5) }
        its([:connect_timeout]) { is_expected.to eq(5) }
      end
    end

    describe ".default_client" do
      subject(:default_client) { described_class.default_client }

      before do
        allow(described_class).to receive(:new).with(described_class.default_conn).and_call_original
      end

      it { is_expected.to be_an_instance_of(described_class) }

      it "assigns the client to the given thread" do
        expect { default_client }
          .to change { Thread.current[:captain_default_client] }
          .to(be_an_instance_of(described_class))
      end
    end

    describe "#request" do
      subject(:request) { described_class.default_client.request(verb, "/ip_address", {}) }

      let(:verb)        { :get }

      context "when a request has a valid verb method" do
        subject { request.response }

        before  { mock_http_request!(verb) }

        context "when GET" do
          let(:verb)   { :get }

          its(:body)   { is_expected.to eq("\"get_request\"") }
          its(:status) { is_expected.to be_success }
        end

        context "when POST" do
          let(:verb)   { :post }

          its(:body)   { is_expected.to eq("\"post_request\"") }
          its(:status) { is_expected.to be_success }
        end
      end

      describe "Raising Exceptions" do
        context "when TheCaptain.raise_http_errors? is truthful" do
          before { allow(TheCaptain).to receive(:raise_http_errors?).and_return(true) }

          it "raises an API Auth error when status code is 401" do
            mock_client_get!(status_code: 401)
            expect { request }.to raise_error Error::APIAuthorizationError
          end

          it "raises an API Connection error when status code is between 500 & 502" do
            mock_client_get!(status_code: [500, 501, 502].sample)
            expect { request }.to raise_error Error::APIConnectionError
          end
        end

        context "when TheCaptain.raise_http_errors? is false" do
          before do
            allow(TheCaptain).to receive(:raise_http_errors?).and_return(false)
            mock_client_get!(status_code: 401)
          end

          it "does not raise any exceptions based on a bad status" do
            expect { request }.not_to raise_error
          end
        end
      end

      context "when validation errors occur" do
        let(:verb) { %i[put patch].sample }

        it "raises an error when a api key empty" do
          reset_configurations!
          expect { request }.to raise_error Error::ClientAuthenticationError
        end

        it "raises an error if its not a whitelisted request method" do
          expect { request }.to raise_error Error::ClientInvalidRequestError
        end
      end
    end

    describe "#decode_response" do
      subject(:decoded_response) { described_class.active_client.decode_response }

      context "when a request is already been made prior" do
        let(:payload) { http_response(payload: { hello: "world" }.to_json) }

        before { described_class.active_client.instance_variable_set(:@response, payload) }

        it { is_expected.to be_an_instance_of(Response::CaptainVessel) }
      end

      context "when no Requests have been made" do
        it "raises an error" do
          expect { decoded_response }.to raise_error Error::ClientError
        end
      end
    end
  end
end
