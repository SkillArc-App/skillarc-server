module Coaches
  class FeedAggregator < MessageConsumer
    def reset_for_replay
      FeedEvent.delete_all
    end

    on_message People::Events::PersonApplied::V1 do |message|
      data = message.data

      FeedEvent.create!(
        person_id: message.stream.id,
        occurred_at: message.occurred_at,
        person_email: data.seeker_email,
        person_phone: data.seeker_phone_number,
        description: "#{data.seeker_first_name} #{data.seeker_last_name} applied for #{data.employment_title} at #{data.employer_name}."
      )
    end

    on_message Users::Events::UserCreated::V1 do |message|
      data = message.data

      FeedEvent.create!(
        occurred_at: message.occurred_at,
        person_email: data.email,
        description: "#{data.first_name} #{data.last_name} signed up."
      )
    end
  end
end
