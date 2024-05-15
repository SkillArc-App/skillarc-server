module Events
  module CoachAssignmentWeightAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          weight 0.0..
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coach,
      message_type: Messages::Types::Coaches::COACH_ASSIGNMENT_WEIGHT_ADDED,
      version: 1
    )
  end
end
