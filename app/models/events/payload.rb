module Events
  module Payload
    def schema(&block)
      include(ValueSemantics.for_attributes(&block))
    end

    def from_hash(hash)
      new(**hash)
    end
  end
end
