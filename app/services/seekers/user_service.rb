module Seekers
  class UserService
    include MessageEmitter

    def initialize(user_id)
      @user = User.find(user_id)
    end

    def update(about:, first_name:, last_name:, phone_number:, zip_code:)
      seeker = user.seeker
      return unless seeker

      aggregate = Aggregates::Seeker.new(seeker_id: seeker.id)
      date_of_birth = ::Projectors::Aggregates::GetLast.project(schema: Events::BasicInfoAdded::V1, aggregate:)&.data&.date_of_birth

      user.update!(
        first_name:,
        last_name:,
        phone_number:,
        zip_code:
      )

      seeker.update!(
        about:
      )

      message_service.create!(
        schema: Events::BasicInfoAdded::V1,
        aggregate:,
        data: {
          first_name:,
          last_name:,
          phone_number:,
          date_of_birth:,
          user_id: user.id
        }
      )

      message_service.create!(
        schema: Events::ZipAdded::V1,
        aggregate:,
        data: {
          zip_code:
        }
      )

      message_service.create!(
        schema: Events::SeekerUpdated::V1,
        aggregate:,
        data: {
          about:
        }
      )
    end

    private

    attr_reader :user
  end
end
