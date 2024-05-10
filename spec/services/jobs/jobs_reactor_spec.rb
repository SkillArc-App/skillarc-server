require 'rails_helper'

RSpec.describe Jobs::JobsReactor do
  it_behaves_like "a non replayable message consumer"

  let(:message_service) { MessageService.new }
  let(:consumer) { described_class.new(message_service:) }

  describe "#create_job_attribute" do
    subject { consumer.create_job_attribute(job_id:, attribute_id:, acceptible_set:) }

    let(:job_id) { create(:job).id }
    let(:attribute) { create(:attributes_attribute, set: %w[A B]) }
    let(:attribute_id) { attribute.id }
    let(:acceptible_set) { %w[A] }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::JobAttributeCreated::V1,
        job_id:,
        data: {
          id: kind_of(String),
          attribute_name: attribute.name,
          attribute_id:,
          acceptible_set:
        }
      ).and_call_original

      subject
    end
  end

  describe "#update_job_attribute" do
    subject { consumer.update_job_attribute(job_id: job_attribute.job_id, job_attribute_id:, acceptible_set:) }

    let(:job_attribute) { create(:job_attribute, acceptible_set: %w[A B]) }
    let(:job_attribute_id) { job_attribute.id }
    let(:acceptible_set) { %w[A] }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::JobAttributeUpdated::V1,
        job_id: job_attribute.job_id,
        data: {
          id: job_attribute.id,
          acceptible_set:
        }
      ).and_call_original

      subject
    end
  end

  describe "#destroy_job_attribute" do
    subject { consumer.destroy_job_attribute(job_id: job_attribute.job_id, job_attribute_id:) }

    let(:job_attribute) { create(:job_attribute) }
    let(:job_attribute_id) { job_attribute.id }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::JobAttributeDestroyed::V1,
        job_id: job_attribute.job_id,
        data: {
          id: job_attribute.id
        }
      ).and_call_original

      subject
    end
  end
end
