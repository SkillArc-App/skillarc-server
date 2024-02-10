module Events
  module Payload
    def schema(&)
      include(ValueSemantics.for_attributes(&))
    end

    def from_hash(hash)
      new(**hash)
    end
  end
end
