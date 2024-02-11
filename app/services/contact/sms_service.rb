module Contact
  class SmsService
    def initialize(phone_number, sms_service: Sms::Gateway.build)
      @phone_number = phone_number
      @sms_service = sms_service
    end

    def send_message(message)
      sms_service.send_message(
        phone_number:,
        message:
      )

      EventService.create!(
        event_schema: Events::SmsSent::V1,
        aggregate_id: phone_number,
        data: Events::SmsSent::Data::V1.new(
          phone_number:,
          message:
        )
      )
    end

    private

    attr_reader :phone_number, :sms_service
  end
end
