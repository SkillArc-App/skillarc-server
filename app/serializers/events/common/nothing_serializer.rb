module Events
  module Common
    class NothingSerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize?(argument)
        argument.is_a?(klass)
      end

      def serialize(_message)
        super()
      end

      def deserialize(_hash)
        Nothing
      end

      def klass
        Nothing
      end
    end
  end
end
