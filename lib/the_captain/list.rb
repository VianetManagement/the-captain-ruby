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

  class ListItem < ApiResource
    api_path "/listitem"

    def self.remove_item(options = {})
      contains_required_list?(options)
      delete(options_formatter(options))   # TheCaptain::APIOperations::Crud.delete
    end
  end

  class Lists < ApiResource
    api_path "/lists"

    def self.call(options = {})
      retrieve options_formatter(options)  # TheCaptain::APIOperations::Crud.retrieve
    end
  end
end
