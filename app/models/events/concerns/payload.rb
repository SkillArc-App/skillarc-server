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
          hash[attr.name] = value unless value == Common::UNDEFINED
        end

        hash
      end

      def from_hash(hash)
        new(**hash)
      end
    end
  end
end
