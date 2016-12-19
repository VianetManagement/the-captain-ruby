module TheCaptain::ModelAdapters
  class Railtie < Rails::Railtie
    config.after_initialize do
      require "the_captain"
    end
  end
end
