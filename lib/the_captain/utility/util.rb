module TheCaptain
  module Utility
    module Util
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
    end
  end
end

