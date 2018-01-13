# frozen_string_literal: true

class ListItem < ApiResource
  api_path "/listitem"

  def self.remove_item(options = {})
    contains_required_list?(options)
    delete(options_formatter(options)) # TheCaptain::APIOperations::Crud.delete
  end
end
