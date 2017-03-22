module TheCaptain
  module Utility
    module Util
      def self.symbolize_names(object)
        case object
        when Hash
          object.inject({}) do |new_hash, hash_item|
            key = hash_item.first.try(:to_sym) || hash_item.first
            new_hash[key] = symbolize_names(hash_item.last)
            new_hash
          end
        when Array
          object.map { |value| symbolize_names(value) }
        else
          object
        end
      end

      def self.mashify(hash)
        new_hash = {}

        hash.each do |key, value|
          new_hash[key] =
            case value
            when Hash
              Hashie::Mash.new(value)
            when Array
              value.map { |item| Hashie::Mash.new(item) }
            else
              value
            end
        end

        Hashie::Mash.new(new_hash)
      end
    end
  end
end
