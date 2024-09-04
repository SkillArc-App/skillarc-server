require 'rails_helper'

RSpec.describe Jobs::Projectors::Attributes do
  describe ".project" do
    subject { described_class.new.project(messages) }

    let(:messages) do
      [
        job_attribute_created1,
        job_attribute_created2,
        job_attribute_updated2,
        job_attribute_destoryed1
      ]
    end

    let(:job_id) { SecureRandom.uuid }
    let(:id1) { SecureRandom.uuid }
    let(:id2) { SecureRandom.uuid }
    let(:id3) { SecureRandom.uuid }
    let(:id4) { SecureRandom.uuid }
    let(:a) { SecureRandom.uuid }
    let(:b) { SecureRandom.uuid }
    let(:c) { SecureRandom.uuid }
    let(:d) { SecureRandom.uuid }
    let(:f) { SecureRandom.uuid }

    let(:job_attribute_created1) do
      build(
        :message,
        schema: Jobs::Events::JobAttributeCreated::V2,
        stream_id: job_id,
        data: {
          job_attribute_id: id1,
          attribute_id: id3,
          acceptible_set: [a, b]
        }
      )
    end
    let(:job_attribute_created2) do
      build(
        :message,
        schema: Jobs::Events::JobAttributeCreated::V2,
        stream_id: job_id,
        data: {
          job_attribute_id: id2,
          attribute_id: id4,
          acceptible_set: [c]
        }
      )
    end
    let(:job_attribute_updated2) do
      build(
        :message,
        schema: Jobs::Events::JobAttributeUpdated::V2,
        stream_id: job_id,
        data: {
          job_attribute_id: id2,
          acceptible_set: [d, f]
        }
      )
    end
    let(:job_attribute_destoryed1) do
      build(
        :message,
        schema: Jobs::Events::JobAttributeDestroyed::V2,
        stream_id: job_id,
        data: {
          job_attribute_id: id1
        }
      )
    end

    it "returns the job attributes" do
      expect(subject.attributes).to eq({ id2 =>
        described_class::Attribute.new(
          id: id4,
          acceptible_set: [d, f]
        ) })
    end
  end
end
