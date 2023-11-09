class UserEvents
  def initialize(user)
    @user = user
  end

  def all
    events = Event.where(aggregate_id: user.id).order(occurred_at: :desc)

    events.map do |event|
      event_message = event_message(event)

      next unless event_message

      {
        datetime: event.occurred_at.strftime("%Y-%m-%d %l:%M%p"),
        event_message:,
      }
    end.compact
  end

  private

  def event_message(event)
    case event.event_type
    when Event::EventTypes::USER_CREATED
      "Signed Up"
    end
  end

  attr_reader :user
end
