module Contact
  class ContactAggregator < MessageConsumer
    def reset_for_replay
      Contact::UserContact.delete_all
      Contact::Notification.delete_all
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

    on_message Events::UserBasicInfoAdded::V1 do |message|
      user_contact = Contact::UserContact.find_by!(user_id: message.data.user_id)

      user_contact.update!(
        phone_number: message.data.phone_number,
        preferred_contact: Contact::ContactPreference::SMS
      )
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
