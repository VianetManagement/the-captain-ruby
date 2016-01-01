RSpec.configure do |config|
  config.before(:suite) do
    WebMock.allow_net_connect!
  end

  config.before(:each) do
    WebMock.allow_net_connect!
  end
end
