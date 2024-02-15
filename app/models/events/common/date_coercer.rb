module Events
  module Common
    module DateCoercer
      def self.call(value)
        if value.is_a?(DateTime) || value.is_a?(ActiveSupport::TimeWithZone) || value.is_a?(Time)
          value.to_date
        elsif value.is_a?(String)
          Date.parse(value)
        else
          value
        end
      end
    end
  end
end
