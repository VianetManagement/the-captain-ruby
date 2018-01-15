# frozen_string_literal: true

module TheCaptain
  module Error
    class ValidationError < StandardException
      class << self
        def key_missing(model, field, missing_key)
          new("Missing object-key (#{model}): `#{missing_key}` in #{field}")
        end
      end
    end
  end
end
