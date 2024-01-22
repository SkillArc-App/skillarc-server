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

      CreateEventJob.perform_later(
        event_type: Event::EventTypes::USER_UPDATED,
        aggregate_id: user.id,
        data: {
          first_name:,
          last_name:,
          phone_number:,
          zip_code:
        },
        metadata: {},
        occurred_at: Time.zone.now
      )
    end

    private

    attr_reader :user
  end
end
