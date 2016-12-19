module TheCaptain
  class AuthenticationError < TheCaptainError
    class << self
      def no_key_provided
        new("No API key provided. " \
	        'Set your API key using "TheCaptain.api_key = <API-KEY>". ' \
	        "See https://thecaptain.elevatorup.com for details, or " \
	        "email support@thecaptain.elevatorup.com if you have any questions.")
      end

      def invalid_key_provided
        new("Your API key is invalid, as it contains " \
	        "whitespace. (HINT: You can double-check your API key by emailing us at " \
	        "support@thecaptain.elevatorup.com if you have any questions.)")
      end
    end
  end
end
