module Events
  module ElevatorPitchCreated
    module Data
      class V1
        extend Concerns::Payload

        schema do
          job_id Uuid
          pitch String
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::ELEVATOR_PITCH_CREATED,
      version: 1
    )
  end
end
