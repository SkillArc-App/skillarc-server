module Events
  module Concerns
    module Splat
      def splat
        hash = {}

        self.class.value_semantics.attributes.each do |attr|
          value = send(attr.name)
          hash[attr.name] = value unless value == Common::UNDEFINED
        end

        hash
      end
    end
  end
end
