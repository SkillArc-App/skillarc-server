module Events
  module Common
    class UntypedHashWrapper
      attr_reader :hash

      def initialize(**kwarg)
        @hash = kwarg
      end

      def to_h
        hash.deep_symbolize_keys
      end

      def ==(other)
        self.class == other.class &&
          hash == other.hash
      end
    end
  end
end
