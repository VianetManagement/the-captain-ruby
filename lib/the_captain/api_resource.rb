module TheCaptain
	class ApiResource < Hashie::Mash
		include TheCaptain::Model
		include TheCaptain::APIOperations::Request

    def self.class_name
      self.name.split('::')[-1]
    end
  end
end
