module Contact
  class ContactReactor < MessageConsumer
    on_message Commands::SendMessage::V1 do |message|
      user_contact = Contact::UserContact.find_by!(user_id: message.data.user_id)

      case user_contact.preferred_contact
      when Contact::ContactPreference::SLACK
        text = if message.data.url.present?
                 "*#{message.data.title}*: #{message.data.body} <#{message.data.url}|Link>"
               else
                 "*#{message.data.title}*: #{message.data.body}"
               end

        message_service.create!(
          schema: Commands::SendSlackMessage::V1,
          trace_id: message.trace_id,
          message_id: message.aggregate.message_id,
          data: {
            channel: user_contact.slack_id,
            text:
          }
        )
      when Contact::ContactPreference::EMAIL
        message_service.create!(
          schema: Commands::SendEmailMessage::V1,
          trace_id: message.trace_id,
          message_id: message.aggregate.message_id,
          data: {
            recepent_email: user_contact.email,
            title: message.data.title,
            body: message.data.body,
            url: message.data.url
          }
        )
      when Contact::ContactPreference::SMS
        text = if message.data.url.present?
                 "#{message.data.title}: #{message.data.body} #{message.data.url}"
               else
                 "#{message.data.title}: #{message.data.body}"
               end

        message_service.create!(
          schema: Commands::SendSmsMessage::V3,
          trace_id: message.trace_id,
          message_id: message.aggregate.message_id,
          data: {
            phone_number: user_contact.phone_number,
            message: text
          }
        )
      when Contact::ContactPreference::IN_APP_NOTIFICATION
        message_service.create!(
          schema: Events::NotificationCreated::V3,
          trace_id: message.trace_id,
          message_id: message.aggregate.message_id,
          data: {
            title: message.data.title,
            body: message.data.body,
            url: message.data.url,
            notification_id: SecureRandom.uuid,
            user_id: message.data.user_id
          }
        )
        message_service.create!(
          schema: Events::MessageSent::V1,
          trace_id: message.trace_id,
          message_id: message.aggregate.message_id,
          data: {
            title: message.data.title,
            body: message.data.body,
            url: message.data.url,
            user_id: message.data.user_id
          }
        )
      end
    end
  end
end
