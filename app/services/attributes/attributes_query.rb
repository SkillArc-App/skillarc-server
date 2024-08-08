module Attributes
  class AttributesQuery
    def self.all
      Attribute.all.map { |a| serialize_attribute(a) }
    end

    def self.find(attribute_id)
      serialize_attribute(Attribute.find(attribute_id))
    end

    class << self
      private

      def serialize_attribute(attribute)
        {
          id: attribute.id,
          default: attribute.default,
          description: attribute.description,
          machine_derived: attribute.machine_derived,
          name: attribute.name,
          set: attribute.set
        }
      end
    end
  end
end
