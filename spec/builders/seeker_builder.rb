module Builders
  class SeekerBuilder
    def initialize(message_service)
      @message_service = message_service
    end

    def build( # rubocop:disable Metrics/ParameterLists
      id: SecureRandom.uuid,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      phone_number: Faker::PhoneNumber.phone_number,
      date_of_birth: "10/09/1990"
    )
      user = UserBuilder.new(message_service).build(first_name:, last_name:, email:, phone_number:, person_id: id)

      message_service.create!(
        seeker_id: id,
        schema: Events::SeekerCreated::V1,
        data: {
          user_id: user.id
        }
      )

      message_service.create!(
        seeker_id: id,
        schema: Events::BasicInfoAdded::V1,
        data: {
          user_id: user.id,
          date_of_birth:,
          first_name:,
          last_name:,
          phone_number:
        }
      )

      message_service.create!(
        seeker_id: id,
        schema: Events::OnboardingStarted::V1,
        data: {
          user_id: user.id
        }
      )
      message_service.create!(
        seeker_id: id,
        schema: Events::OnboardingCompleted::V2,
        data: Messages::Nothing
      )

      Seeker.new(
        id:,
        user_id: user.id,
        first_name:,
        last_name:,
        email:,
        phone_number:
      )
    end

    private

    attr_reader :message_service
  end
end
