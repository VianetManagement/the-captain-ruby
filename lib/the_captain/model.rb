module TheCaptain
  module Model
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      # This sets the API path so the API collections can use them in an agnostic way
      # @return [void]
      def api_path(path = nil)
        @_api_path ||= path
      end

      def parse(response)
        TheCaptain.review_response(response)
      end

      def delegate_methods(options)
        raise "no methods given" if options.empty?
        options.each do |source, dest|
          class_eval <<-EOV
            def #{source}
              #{dest}
            end
          EOV
        end
      end
    end # ClassMethods
  end
end
