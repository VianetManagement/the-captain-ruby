# frozen_string_literal: true

module TheCaptain
  class List < ApiResource
    api_path "/list"

    def self.call(name)
      retrieve(value: name) # TheCaptain::APIOperations::Crud.retrieve
    end

    def self.data(options = {})
      contains_required_list?(options)
      submit options_formatter(options)   # TheCaptain::APIOperations::Crud.submit
    end

    def self.remove_list(name)
      delete(value: name)                 # TheCaptain::APIOperations::Crud.delete
    end

    def self.remove_item(options = {})
      ListItem.remove_item(options)
    end
  end
end
