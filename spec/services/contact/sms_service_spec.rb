require 'rails_helper'

RSpec.describe Contact::SmsService do
  describe "#send_message" do
    subject { described_class.new(phone_number, sms_service:).send_message(message) }

    let(:sms_service) { instance_double(Sms::SmsCommunicator, send_message: nil) }

    let(:message) { "Hello, world!" }
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
          message:
        )
      )

      subject
    end
  end
end
