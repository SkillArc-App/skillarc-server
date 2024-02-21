module Messages
  module DateCoercer
    def self.call(value)
      if value.is_a?(DateTime) || value.is_a?(ActiveSupport::TimeWithZone) || value.is_a?(Time)
        value.to_date
      elsif value.is_a?(String)
        if %r{\d{2}/\d{2}/\d{4}}.match(value)
          Date.strptime(value, "%m/%d/%Y")
        else
          Date.strptime(value, "%Y-%m-%d")
        end
      else
        value
      end
    end
  end
end
