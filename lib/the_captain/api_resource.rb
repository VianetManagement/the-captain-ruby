module TheCaptain
	class ApiResource < Hashie::Mash
		include TheCaptain::Model
		include TheCaptain::APIOperations::Request
		include TheCaptain::APIOperations::Read

    def self.class_name
      self.name.split('::')[-1]
    end
  end
end
