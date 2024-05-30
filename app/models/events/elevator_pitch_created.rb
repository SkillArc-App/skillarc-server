module Events
  module ElevatorPitchCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          job_id Uuid
          pitch String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Person::ELEVATOR_PITCH_CREATED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Person::ELEVATOR_PITCH_CREATED,
      version: 2
    )
  end
end
