module Events
  module Common
    class UntypedHashWrapperSerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize?(argument)
        argument.is_a?(klass)
      end

      def serialize(message)
        super(
          "hash" => message.hash,
        )
      end

      def deserialize(hash)
        klass.new(hash["hash"])
      end

      def klass
        UntypedHashWrapper
      end
    end
  end
end
