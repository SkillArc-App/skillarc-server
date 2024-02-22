module Contact
  class SmsService < EventConsumer
    def handled_events
      [
        Commands::SendSms::V1
      ]
    end

    def handle_message(message, *_params)
      case message.event_schema
      when Commands::SendSms::V1
        handle_send_sms(message)
      end
    end

    def reset_for_replay; end

    def initialize(sms_service: Sms::Gateway.build)
      super()
      @sms_service = sms_service
    end

    private

    def handle_send_sms(message)
      sms_service.send_message(
        phone_number: message.data.phone_number,
        message: message.data.message
      )

      EventService.create!(
        event_schema: Events::SmsSent::V1,
        aggregate_id: message.data.phone_number,
        data: Events::SmsSent::Data::V1.new(
          phone_number: message.data.phone_number,
          message: message.data.message
        )
      )
    end

    attr_reader :sms_service
  end
end
