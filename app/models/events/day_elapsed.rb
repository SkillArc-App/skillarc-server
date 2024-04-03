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
        extend Messages::Payload

        schema do
          date Date, coerce: Messages::DateCoercer
          day_of_week Either(*DaysOfWeek::ALL)
        end
      end
    end

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Day,
      message_type: Messages::Types::DAY_ELAPSED,
      version: 1
    )
  end
end
