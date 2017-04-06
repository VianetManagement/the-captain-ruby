module TheCaptain
  class List < ApiResource
    api_path "/list"
  end

  class Lists < ApiResource
    api_path "/lists"

    def self.retrieve(*_)
      super("")
    end

    def self.submit(*_)
      raise TheCaptain.client_error(class_name, "Cannot submit multiple lists")
    end

    def self.delete(*_)
      raise TheCaptain.client_error(class_name, "Cannot delete lists")
    end
  end

  class ListItem < ApiResource
    api_path "/listitem"

    def self.retrieve(*_)
      raise TheCaptain.client_error(class_name, "Cannot retrieve an item from a list, use TheCaptain::List")
    end

    def self.submit(*_)
      raise TheCaptain.client_error(class_name, "Cannot submit a list item through this path, use TheCaptain::List")
    end

    def self.delete(name, options = {})
      options = resolve_items(options)
      super
    end

    def self.resolve_items(options)
      if options[:items].blank? && options[:item].blank?
        raise ArgumentError, "You must submit an array of items containing at least 1 element"
      end

      items = options.delete(:items)
      items ||= options.delete(:item)
      options.merge!(items: items.is_a?(Array) ? items : [items])
    end
  end
end
