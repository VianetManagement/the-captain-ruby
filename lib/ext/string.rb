unless String.respond_to?(:blank?)
  class String
    def blank?
    	self == nil || self.length == 0
    end

    def present?
    	!blank?
    end
  end
end
