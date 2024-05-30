module People
  class BasicInfoService
    def initialize(user_id, message_service)
      @user = User.find(user_id)
      @message_service = message_service
    end

    def update(about:, first_name:, last_name:, phone_number:, zip_code:)
      seeker = user.seeker
      return unless seeker

      aggregate = Aggregates::Person.new(person_id: seeker.id)
      email = ::Projectors::Aggregates::GetLast.project(schema: Events::BasicInfoAdded::V1, aggregate:)&.data&.email

      message_service.create!(
        schema: Events::BasicInfoAdded::V1,
        aggregate:,
        data: {
          first_name:,
          last_name:,
          phone_number:,
          email:
        }
      )

      message_service.create!(
        schema: Events::ZipAdded::V2,
        aggregate:,
        data: {
          zip_code:
        }
      )

      message_service.create!(
        schema: Events::PersonAboutAdded::V1,
        aggregate:,
        data: {
          about:
        }
      )
    end

    private

    attr_reader :user, :message_service
  end
end
