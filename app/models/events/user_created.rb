module Events
  module UserCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          first_name Either(String, nil), default: nil
          last_name Either(String, nil), default: nil
          email Either(String, nil), default: nil
          sub Either(String, nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::USER_CREATED,
      version: 1
    )
  end
end
