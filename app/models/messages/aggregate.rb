module Messages
  class Aggregate
    IdNameNotSymbolError = Class.new(StandardError)
    IdNameNotSetError = Class.new(StandardError)
    IdNameAlreadySetError = Class.new(StandardError)

    def self.id_name(name)
      raise IdNameNotSymbolError unless name.is_a?(Symbol)
      raise IdNameAlreadySetError if @id_name.present?

      @id_name = name

      define_method(name) do
        id
      end
    end

    def self.id
      raise IdNameNotSetError if @id_name.blank?

      @id_name
    end

    def initialize(**kwarg)
      value = kwarg[self.class.id]
      raise ArgumentError, "Expected keyword argument #{self.class.id} for #{self.class.name}" if value.blank?

      @id = value
    end

    def ==(other)
      id == other.id && self.class == other.class
    end

    attr_reader :id
  end
end
