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
      user_id = SecureRandom.uuid
      user = UserBuilder.new(message_service).build(id: user_id, first_name:, last_name:, email:, phone_number:, person_id: id)

      message_service.create!(
        person_id: id,
        schema: Events::PersonAdded::V1,
        data: {
          first_name:,
          last_name:,
          email:,
          phone_number:
        }
      )
      message_service.create!(
        person_id: id,
        schema: Events::PersonAssociatedToUser::V1,
        data: {
          user_id:
        }
      )

      message_service.create!(
        person_id: id,
        schema: Events::DateOfBirthAdded::V1,
        data: {
          date_of_birth:
        }
      )

      message_service.create!(
        person_id: id,
        schema: Events::OnboardingStarted::V2,
        data: Messages::Nothing
      )
      message_service.create!(
        person_id: id,
        schema: Events::OnboardingCompleted::V3,
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
