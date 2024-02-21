module Messages
  class UntypedHashWrapper
    attr_reader :instance_hash

    def initialize(instance_hash)
      @instance_hash = instance_hash.deep_symbolize_keys
    end

    delegate :[], to: :instance_hash
    delegate :fetch, to: :instance_hash

    def to_h
      instance_hash.clone
    end

    def ==(other)
      self.class == other.class &&
        instance_hash == other.instance_hash
    end

    def self.from_hash(instance_hash)
      new(instance_hash)
    end

    def self.build(**kwarg)
      new(kwarg)
    end
  end
end
