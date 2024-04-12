module Contact
  class SmsReactor < MessageConsumer
    def reset_for_replay; end

    def initialize(sms_service: Sms::Gateway.build, **params)
      super(**params)
      @sms_service = sms_service
    end

    on_message Commands::SendSms::V2 do |message|
      sms_service.send_message(
        phone_number: message.data.phone_number,
        message: message.data.message
      )

      message_service.create!(
        schema: Events::SmsSent::V1,
        phone_number: message.data.phone_number,
        trace_id: message.trace_id,
        data: {
          phone_number: message.data.phone_number,
          message: message.data.message
        }
      )
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    private

    attr_reader :sms_service
  end
end
