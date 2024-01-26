module Events
  module Common
    class Nothing
      def self.===(other)
        other == Nothing
      end

      def self.to_h
        {}
      end
    end
  end
end
