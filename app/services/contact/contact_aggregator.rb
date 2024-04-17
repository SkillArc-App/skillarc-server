module Contact
  class ContactAggregator < MessageConsumer
    def reset_for_replay
      Contact::UserContact.delete_all
      Contact::Notification.delete_all
      Contact::MessageState.delete_all
    end

    on_message Events::NotificationCreated::V3, :sync do |message|
      Contact::Notification.create!(
        id: message.data.notification_id,
        user_id: message.data.user_id,
        title: message.data.title,
        body: message.data.body,
        url: message.data.url
      )
    end

    on_message Events::NotificationMarkedRead::V2, :sync do |message|
      notification = Contact::Notification.where(id: message.data.notification_ids)
      notification.update_all(read_at: message.occurred_at) # rubocop:disable Rails/SkipsModelValidations
    end

    on_message Events::MessageEnqueued::V1, :sync do |message|
      Contact::MessageState.create!(
        message_enqueued_at: message.occurred_at,
        state: Contact::MessageStates::ENQUEUED,
        message_id: message.aggregate.message_id
      )
    end

    on_message Events::UserCreated::V1 do |message|
      preferred_contact = if message.data.email.nil?
                            Contact::ContactPreference::IN_APP_NOTIFICATION
                          else
                            Contact::ContactPreference::EMAIL
                          end

      Contact::UserContact.create!(
        user_id: message.aggregate.user_id,
        email: message.data.email,
        preferred_contact:
      )
    end

    on_message Events::MessageSent::V1 do |message|
      Contact::MessageState.find_by!(message_id: message.aggregate.message_id).complete!(message_terminated_at: message.occurred_at)
    end

    on_message Events::UserUpdated::V1 do |message|
      user_contact = Contact::UserContact.find_by!(user_id: message.aggregate.user_id)

      data = message.data.serialize

      user_contact.email = data[:email] if data.key?(:email)
      user_contact.phone_number = data[:phone_number]
      user_contact.preferred_contact = Contact::ContactPreference::SMS

      user_contact.save!
    end

    on_message Events::SlackIdAdded::V1 do |message|
      user_contact = Contact::UserContact.find_by!(user_id: message.aggregate.user_id)

      user_contact.update!(
        slack_id: message.data.slack_id
      )
    end

    on_message Events::ContactPreferenceSet::V1 do |message|
      user_contact = Contact::UserContact.find_by!(user_id: message.aggregate.user_id)

      user_contact.update!(
        preferred_contact: message.data.preference
      )
    end
  end
end
