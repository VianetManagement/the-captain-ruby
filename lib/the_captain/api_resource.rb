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

    def self.retrieve(identifier, options = {})
      options = pagination_options(options)
      options = user_id_options(options)
      super
    end

    def self.user_id_options(options)
      return options unless options[:user]
      user = options.delete(:user)
      user_is_id = user.is_a?(Numeric) || user.is_a?(Symbol)
      return options if !user_is_id && user.blank?

      user_is_id = user_is_id || user.is_a?(String)
      options.merge!(user_id: user_is_id ? user : user.id)
    end

    # Convert kasmair pagination into geo4 params
    def self.pagination_options(options)
      options[:limit] = options.delete(:per) if options[:per]
      options[:skip] = options.delete(:page) if options[:page]
      options
    end
  end
end
