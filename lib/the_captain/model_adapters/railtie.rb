# frozen_string_literal: true

module TheCaptain::ModelAdapters
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer "the_captain" do
      require "the_captain"
    end
  end
end
