module Events
  module Concerns
    module Payload
      def schema(&)
        include(ValueSemantics.for_attributes(&))
        include Concerns::Payload
      end

      def to_h
        hash = {}

        self.class.value_semantics.attributes.each do |attr|
          value = send(attr.name)
          value = value.to_h if attr.validator.respond_to?(:to_h)
          hash[attr.name] = value unless value == Common::UNDEFINED
        end

        hash
      end

      def from_hash(hash)
        deserialized_hash = {}

        value_semantics.attributes.each do |attr|
          # If a child is also a payload call from_hash as well verse taking the straight value
          next unless hash.key?(attr.name)

          value = hash[attr.name]
          value = attr.validator.from_hash(value) if attr.validator.respond_to?(:from_hash)

          deserialized_hash[attr.name] = value
        end

        new(**deserialized_hash)
      end
    end
  end
end
