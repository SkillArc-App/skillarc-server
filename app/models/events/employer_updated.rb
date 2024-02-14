module Events
  module EmployerUpdated
    module Data
      class V1
        extend Payload

        schema do
          name String
          location String
          bio String
          logo_url String
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EMPLOYER_UPDATED,
      version: 1
    )
  end
end
