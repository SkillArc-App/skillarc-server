require 'rails_helper'

RSpec.describe Jobs::JobsAggregator do
  it_behaves_like "a message consumer"

  let(:consumer) { described_class.new(message_service: MessageService.new) }

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "JobAttributeCreated" do
      let(:message) do
        build(
          :message,
          schema: Events::JobAttributeCreated::V1,
          aggregate_id: job.id,
          data: {
            id:,
            attribute_name: "name",
            attribute_id: SecureRandom.uuid,
            acceptible_set: %w[A B]
          }
        )
      end
      let(:id) { SecureRandom.uuid }
      let(:attribute_id) { SecureRandom.uuid }
      let(:job) { create(:job) }

      it "creates a job attribute" do
        expect { subject }.to change { JobAttribute.count }.by(1)
      end
    end

    context "JobAttributeUpdated" do
      let(:message) do
        build(
          :message,
          schema: Events::JobAttributeUpdated::V1,
          aggregate_id: job_attribute.job_id,
          data: {
            id: job_attribute.id,
            acceptible_set: %w[A B]
          }
        )
      end
      let(:job_attribute) { create(:job_attribute, acceptible_set: %w[A]) }

      it "updates a job attribute" do
        subject

        expect(job_attribute.reload.acceptible_set).to eq(%w[A B])
      end
    end

    context "JobAttributeDestroyed" do
      let(:message) do
        build(
          :message,
          schema: Events::JobAttributeDestroyed::V1,
          aggregate_id: job_attribute.job_id,
          data: {
            id: job_attribute.id
          }
        )
      end
      let(:job_attribute) { create(:job_attribute) }

      it "destroys a job attribute" do
        job_attribute

        expect { subject }.to change { JobAttribute.count }.by(-1)
      end
    end
  end
end
