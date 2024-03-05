module Contact
  class SmsService < MessageConsumer
    def reset_for_replay; end

    def initialize(sms_service: Sms::Gateway.build)
      super()
      @sms_service = sms_service
    end

    on_message Commands::SendSms::V1 do |message|
      sms_service.send_message(
        phone_number: message.data.phone_number,
        message: message.data.message
      )

      EventService.create!(
        event_schema: Events::SmsSent::V1,
        aggregate_id: message.data.phone_number,
        trace_id: message.trace_id,
        data: Events::SmsSent::Data::V1.new(
          phone_number: message.data.phone_number,
          message: message.data.message
        )
      )
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    private

    attr_reader :sms_service
  end
end
