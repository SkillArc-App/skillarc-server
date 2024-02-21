module Messages
  module Payload
    def schema(&)
      include(ValueSemantics.for_attributes(&))
      include Messages::Payload
    end

    def to_h
      hash = {}

      self.class.value_semantics.attributes.each do |attr|
        value = to_h_value(attr.validator, send(attr.name))
        hash[attr.name] = value unless value == Messages::UNDEFINED
      end

      hash
    end

    def from_hash(hash)
      deserialized_hash = {}

      value_semantics.attributes.each do |attr|
        # If a child is also a payload call from_hash as well verse taking the straight value
        next unless hash.key?(attr.name)

        value = from_hash_value(attr.validator, hash[attr.name])
        deserialized_hash[attr.name] = value
      end

      new(**deserialized_hash)
    end

    private

    def to_h_value(validator, value)
      if validator.is_a?(ValueSemantics::ArrayOf)
        if validator.element_validator.respond_to?(:to_h)
          value.map(&:to_h)
        else
          value
        end
      elsif validator.respond_to?(:to_h)
        value.to_h
      else
        value
      end
    end

    def from_hash_value(validator, value)
      if validator.is_a?(ValueSemantics::ArrayOf)
        value.map { |v| from_hash_value(validator.element_validator, v) }
      elsif validator.respond_to?(:from_hash)
        validator.from_hash(value)
      else
        value
      end
    end
  end
end
