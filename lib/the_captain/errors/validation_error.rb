module TheCaptain
  class ValidationError < TheCaptainError
    class << self
      def key_missing(model, field, missing_key)
        new("Missing object-key (#{model}): `#{missing_key}` in #{field}")
      end
    end
  end
end
