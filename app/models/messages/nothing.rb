module Messages
  class Nothing
    def self.===(other)
      other == Nothing
    end

    def self.to_h
      {}
    end

    def self.from_hash(_hash)
      self
    end
  end
end
