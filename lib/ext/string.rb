unless String.respond_to?(:blank?)
  class String
    def blank?
      nil? || empty?
    end

    def present?
      !blank?
    end
  end
end
