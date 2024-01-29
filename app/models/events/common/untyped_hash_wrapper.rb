module Events
  module Common
    class UntypedHashWrapper
      attr_reader :hash

      def initialize(hash)
        @hash = hash.deep_symbolize_keys
      end

      def [](index)
        @hash[index]
      end

      def to_h
        hash.clone
      end

      def ==(other)
        self.class == other.class &&
          hash == other.hash
      end

      def self.from_hash(hash)
        new(hash)
      end

      def self.build(**kwarg)
        new(kwarg)
      end
    end
  end
end
