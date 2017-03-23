module TheCaptain
  class List < ApiResource
    api_path "/list"
  end

  class Lists < ApiResource
    api_path "/lists"

    def self.submit(*_)
      raise TheCaptain.client_error(class_name, "Cannot submit multiple lists")
    end

    def self.retrieve(*_)
      super("")
    end
  end
end
