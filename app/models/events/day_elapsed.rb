module Events
  module DayElapsed
    module Data
      module DaysOfWeek
        ALL = [
          MONDAY = 'monday'.freeze,
          TUESDAY = 'tuesday'.freeze,
          WEDNESDAY = 'wednesday'.freeze,
          THURSDAY = 'thursday'.freeze,
          FRIDAY = 'friday'.freeze,
          SATURDAY = 'saturday'.freeze,
          SUNDAY = 'sunday'.freeze
        ].freeze
      end

      class V1
        extend Concerns::Payload

        schema do
          date Date, coerce: Common::DateCoercer
          day_of_week Either(*DaysOfWeek::ALL)
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::DAY_ELAPSED,
      version: 1
    )
  end
end
