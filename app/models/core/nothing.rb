module Core
  class Nothing
    def self.===(other)
      other == Nothing
    end

    def self.serialize
      {}
    end

    def self.deserialize(_hash)
      self
    end
  end
end
