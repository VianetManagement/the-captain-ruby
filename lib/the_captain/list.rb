module TheCaptain
  class List < ApiResource
    api_path "/list"

    def delete(*_)
      raise TheCaptain.client_error(class_name, "Cannot delete a list")
    end
  end

  class Lists < ApiResource
    api_path "/lists"

    def self.submit(*_)
      raise TheCaptain.client_error(class_name, "Cannot submit multiple lists")
    end

    def delete(*_)
      raise TheCaptain.client_error(class_name, "Cannot delete lists")
    end

    def self.retrieve(*_)
      super("")
    end
  end

  class ListItem
    ApiResource.api_path "/listitem"

    def self.delete(name, options = {})
      options = resolve_items(options)
      ApiResource.delete(name, options)
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
