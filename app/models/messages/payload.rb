module Messages
  module Payload
    def schema(&)
      include(ValueSemantics.for_attributes(&))
      include Messages::Payload
    end

    delegate :to_h, to: :serialize

    def serialize
      hash = {}

      self.class.value_semantics.attributes.each do |attr|
        value = to_serialized_value(send(attr.name))
        hash[attr.name] = value unless value == Messages::UNDEFINED
      end

      hash
    end

    def deserialize(hash)
      deserialized_hash = {}

      value_semantics.attributes.each do |attr|
        # If a child is also a payload call from_hash as well verse taking the straight value
        next unless hash.key?(attr.name)

        value = from_serialized_value(attr.validator, hash[attr.name])
        deserialized_hash[attr.name] = value
      end

      new(**deserialized_hash)
    end

    private

    def to_serialized_value(value)
      if value.is_a?(Array)
        if value.first.respond_to?(:serialize)
          value.map(&:serialize)
        elsif value.first.respond_to?(:to_h)
          value.map(&:to_h)
        else
          value
        end
      elsif value.nil?
        nil
      elsif value.respond_to?(:serialize)
        value.serialize
      elsif value.respond_to?(:to_h)
        value.to_h
      else
        value
      end
    end

    def from_serialized_value(validator, value)
      if validator.is_a?(ValueSemantics::ArrayOf)
        value.map { |v| from_serialized_value(validator.element_validator, v) }
      elsif validator.respond_to?(:deserialize)
        validator.deserialize(value)
      else
        value
      end
    end
  end
end
