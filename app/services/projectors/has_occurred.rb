module Projectors
  class HasOccurred
    def project(messages)
      messages.detect { |m| m.schema == schema }.present?
    end

    def initialize(schema:)
      @schema = schema
    end

    private

    attr_reader :schema
  end
end
