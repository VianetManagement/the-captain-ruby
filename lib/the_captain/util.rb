module TheCaptain
  module Util
    SUPPORTED_QUERY_OPTIONS = [
      :event_name,
      :user_id,
      :before,
      :after,
      :filters,
    ].freeze

    SUPPORTED_QUERY_FILTERS = [
      :ne,
      :eq,
    ].freeze

    def self.symbolize_names(object)
      case object
      when Hash
        new_hash = {}
        object.each do |key, value|
          key = (begin
                  key.to_sym
                rescue
                  key
                end) || key
          new_hash[key] = symbolize_names(value)
        end
        new_hash
      when Array
        object.map { |value| symbolize_names(value) }
      else
        object
      end
    end

    def self.parse_query_options(options)
      safe_query = {}

      options.each_pair do |key, value|
        safe_query[key] = value if SUPPORTED_QUERY_OPTIONS.include?(key)

        if key == :filters
          safe_query[:filters] = value.keep_if { |key, _| SUPPORTED_QUERY_FILTERS.include?(key) }
        end
      end

      safe_query
    end

    def self.mashify(hash)
      new_hash = {}

      hash.keys.each do |key|
        if hash[key].is_a?(Array)
          items = hash.delete(key)
          new_hash[key] = items.map { |item| Hashie::Mash.new(item) }
        elsif hash[key].is_a?(Hash)
          new_hash[key] = Hashie::Mash.new(hash.delete(key))
        else
          new_hash[key] = hash[key]
        end
      end

      Hashie::Mash.new(new_hash)
    end

    def self.objects_to_ids(h)
      case h
      when APIResource
        h.id
      when Hash
        res = {}
        h.each { |k, v| res[k] = objects_to_ids(v) unless v.nil? }
        res
      when Array
        h.map { |v| objects_to_ids(v) }
      else
        h
      end
    end
  end
end
