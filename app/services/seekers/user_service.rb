module Seekers
  class UserService
    def initialize(user_id)
      @user = User.find(user_id)
    end

    def update(about:, first_name:, last_name:, phone_number:, zip_code:)
      user.update!(
        first_name:,
        last_name:,
        phone_number:,
        zip_code:
      )

      EventService.create!(
        event_schema: Events::UserUpdated::V1,
        user_id: user.id,
        data: Events::UserUpdated::Data::V1.new(
          first_name:,
          last_name:,
          phone_number:,
          zip_code:
        ),
        occurred_at: Time.zone.now
      )

      seeker = user.seeker

      return unless seeker

      seeker.update!(
        about:
      )

      EventService.create!(
        event_schema: Events::SeekerUpdated::V1,
        seeker_id: seeker.id,
        data: Events::SeekerUpdated::Data::V1.new(
          about:
        ),
        occurred_at: Time.zone.now
      )
    end

    private

    attr_reader :user
  end
end
