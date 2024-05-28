module Builders
  class UserBuilder
    def initialize(message_service)
      @message_service = message_service
    end

    def build( # rubocop:disable Metrics/ParameterLists
      id: SecureRandom.uuid,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      phone_number: Faker::PhoneNumber.phone_number,
      sub: Faker::Internet.uuid,
      person_id: nil
    )
      user = User.create!(
        id:,
        first_name:,
        last_name:,
        email:,
        phone_number:,
        sub:,
        person_id:
      )

      message_service.create!(
        user_id: id,
        schema: Events::UserCreated::V1,
        data: {
          first_name:,
          last_name:,
          email:,
          sub:
        }
      )

      user
    end

    private

    attr_reader :message_service
  end
end
