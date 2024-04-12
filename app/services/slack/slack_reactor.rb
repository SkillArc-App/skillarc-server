module Slack
  class SlackReactor < MessageConsumer
    def initialize(client: Slack::Gateway.build, **params)
      super(**params)
      @client = client
    end

    on_message Commands::SendSlackMessage::V1 do |message|
      client.chat_postMessage(
        channel: message.data.channel,
        text: message.data.text,
        as_user: true
      )

      message_service.create!(
        schema: ::Events::SlackMessageSent::V1,
        trace_id: message.trace_id,
        message_id: message.aggregate.message_id,
        data: message.data.to_h
      )
    end

    on_message ::Events::ApplicantStatusUpdated::V5 do |message|
      data = message.data
      return unless data.status == ApplicantStatus::StatusTypes::NEW

      client.chat_postMessage(
        channel: '#feed',
        text: "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{data.seeker_id}|#{data.applicant_email}> has applied to *#{data.employment_title}* at *#{data.employer_name}*",
        as_user: true
      )
    end

    on_message ::Events::ChatMessageSent::V1 do |message|
      data = message.data

      seeker = Seeker.find(data.seeker_id)
      from_user_id = message.data.from_user_id

      message = if seeker.user.id == from_user_id
                  "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{seeker.id}|#{seeker.user.email}> has *sent* a message to *#{data.employer_name}* for their applcation to *#{data.employment_title}*."
                else
                  "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{seeker.id}|#{seeker.user.email}> has *received* a message from *#{data.employer_name}* for their applcation to *#{data.employment_title}*."
                end

      client.chat_postMessage(
        channel: '#feed',
        text: message,
        as_user: true
      )
    end

    on_message ::Events::UserCreated::V1 do |message|
      client.chat_postMessage(
        channel: '#feed',
        text: "New user signed up: *#{message.data.email}*",
        as_user: true
      )
    end

    private

    attr_reader :client
  end
end
