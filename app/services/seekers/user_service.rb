module Seekers
  class UserService
    def initialize(user_id)
      @user = User.find(user_id)
    end

    def update(first_name:, last_name:, phone_number:, zip_code:)
      user.update!(
        first_name:,
        last_name:,
        phone_number:,
        zip_code:
      )

      EventService.create!(
        event_schema: Events::UserUpdated::V1,
        aggregate_id: user.id,
        data: Events::Common::UntypedHashWrapper.new(
          first_name:,
          last_name:,
          phone_number:,
          zip_code:
        ),
        occurred_at: Time.zone.now
      )
    end

    private

    attr_reader :user
  end
end
