module TheCaptain
  class ApiResource < Hashie::Mash
    include TheCaptain::Model
    include TheCaptain::APIOperations::Request
    include TheCaptain::APIOperations::Read
    include TheCaptain::APIOperations::Query
    include TheCaptain::APIOperations::Create

    def self.class_name
      name.split("::")[-1]
    end

    def self.pagination_options(options)
      return options unless options[:per]
      options.merge!(limit: options.delete(:per))
    end
  end
end
