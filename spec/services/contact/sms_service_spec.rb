require 'rails_helper'

RSpec.describe Contact::SmsService do
  describe "#handle_event" do
    subject { described_class.new(sms_service:).handle_event(message) }

    let(:sms_service) { instance_double(Sms::SmsCommunicator, send_message: nil) }
    let(:message) do
      build(
        :message,
        :send_sms,
        data: Commands::SendSms::Data::V1.new(
          phone_number:,
          message: sms_message
        )
      )
    end

    let(:sms_message) { "Hello, world!" }
    let(:phone_number) { "1234567890" }

    it "calls the Sms Gateway" do
      expect(sms_service).to receive(:send_message).with(
        phone_number: "1234567890",
        message: "Hello, world!"
      )

      subject
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::SmsSent::V1,
        aggregate_id: phone_number,
        data: Events::SmsSent::Data::V1.new(
          phone_number:,
          message: sms_message
        )
      )

      subject
    end
  end
end
