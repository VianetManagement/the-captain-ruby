# frozen_string_literal: true

module CaptainClientRequestHelper
  def mock_http_conn
    instance_double(
      "HTTP::Chainable",
      default_options: instance_double("HTTP::Options", headers: { "X-API-KEY" => "test-key" }),
    )
  end

  def http_response(status_code: 200, payload: nil)
    payload = payload.respond_to?(:to_json) ? payload.to_json : payload
    HTTP::Response.new(status: status_code, body: payload, version: "1")
  end

  def mock_default_conn
    Thread.current[:captain_default_conn] = mock_http_conn
  end

  def mock_http_request!(verb, **options)
    send(:"mock_client_#{verb}!", **options)
  end

  def mock_client_get!(payload: :get_request, status_code: 200)
    response = http_response(payload: payload, status_code: status_code)
    allow(mock_default_conn).to receive(:get).and_return(response)
  end

  def mock_client_post!(payload: :post_request, status_code: 200)
    response = http_response(payload: payload, status_code: status_code)
    allow(mock_default_conn).to receive(:post).and_return(response)
  end

  def mock_client_patch!(payload: :patch_request, status_code: 200)
    response = http_response(payload: payload, status_code: status_code)
    allow(mock_default_conn).to receive(:patch).and_return(response)
  end
end

RSpec.configure do |config|
  config.include(CaptainClientRequestHelper)
  config.before do
    Thread.current[:captain_default_client] = nil
    Thread.current[:captain_default_conn] = nil
  end
end
