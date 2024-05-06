module Events
  module RoleAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          role Either(*Role::Types::ALL)
          email String
          coach_id Either(Uuid, nil), default: nil
        end
      end

      class V2
        extend Messages::Payload

        schema do
          role Either(*Role::Types::ALL)
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::ROLE_ADDED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::ROLE_ADDED,
      version: 2
    )
  end
end
