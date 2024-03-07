module Events
  module MetCareerCoachUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          met_career_coach Bool()
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::MET_CAREER_COACH_UPDATED,
      version: 1
    )
  end
end
