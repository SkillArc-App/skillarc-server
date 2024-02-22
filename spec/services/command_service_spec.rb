require 'rails_helper'

RSpec.describe CommandService do
  describe ".create!" do
    subject do
      described_class.create!(
        id:,
        command_schema:,
        aggregate_id:,
        trace_id:,
        data:,
        occurred_at:,
        metadata:
      )
    end

    let(:aggregate_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Commands::SendSms::Data::V1.new(phone_number: "1234567890", message: "cool") }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:command_schema) { Commands::SendSms::V1 }
    let(:metadata) { Messages::Nothing }
    let(:id) { SecureRandom.uuid }

    it "calls EventService.create! with the same data" do
      expect(EventService)
        .to receive(:create!)
        .with(
          id:,
          event_schema: command_schema,
          aggregate_id:,
          trace_id:,
          data:,
          occurred_at:,
          metadata:
        )

      subject
    end
  end
end
