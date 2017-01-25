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
      options = time_options(options)
      super
    end

    def self.user_id_options(options)
      user = options.delete(:user)
      return options if user.blank?
      options.merge!(user_id: user_id_extract(user))
    end

    # Convert kasmair pagination into geo4 params
    def self.pagination_options(options)
      options[:limit] = options.delete(:per) if options[:per]
      options[:skip] = options.delete(:page) if options[:page]
      options
    end

    def self.user_id_extract(user)
      user.respond_to?(:id) ? user.id : user
    end

    def self.time_options(options)
      options[:from] = milliseconds(options[:from]) if options[:from]
      options[:to] = milliseconds(options[:to]) if options[:to]
      options
    end

    def self.milliseconds(time)
      (time.to_f * 1000).to_i
    end
  end
end
