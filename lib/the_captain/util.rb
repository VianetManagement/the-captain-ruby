module TheCaptain
	module Util
		SUPPORTED_QUERY_OPTIONS = [
			:event_name,
			:before,
			:after,
			:filters
		].freeze

		SUPPORTED_QUERY_FILTERS = [
			:ne,
			:eq
		].freeze

		def self.symbolize_names(object)
      case object
      when Hash
        new_hash = {}
        object.each do |key, value|
          key = (key.to_sym rescue key) || key
          new_hash[key] = symbolize_names(value)
        end
        new_hash
      when Array
        object.map{ |value| symbolize_names(value) }
      else
        object
      end
    end

    def self.parse_query(query)
    	safe_query = {}

    	 query.each_pair do |key, value|
    		safe_query[key] = value if SUPPORTED_QUERY_OPTIONS.include(key)

    		if key == :filters
    			safe_query[:filters] = value.keep_if{ |key, _| SUPPORTED_SUPPORTED_QUERY_FILTERS.include(key) }
    		end
    	end

    	safe_query
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
