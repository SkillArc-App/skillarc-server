require 'rails_helper'

RSpec.describe Seekers::SeekerReactor do
  it_behaves_like "a message consumer"

  let(:consumer) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }

  describe "add_experience" do
    subject do
      consumer.add_experience(
        seeker_id:,
        organization_name:,
        position:,
        start_date:,
        end_date:,
        is_current:,
        description:,
        trace_id:
      )
    end

    let(:seeker_id) { SecureRandom.uuid }
    let(:organization_name) { "Some org" }
    let(:position) { "Best position" }
    let(:start_date) { "2000-10-25" }
    let(:end_date) { "2005-3-25" }
    let(:is_current) { true }
    let(:description) { "It was a great job" }
    let(:trace_id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::ExperienceAdded::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: be_a(String),
            organization_name:,
            position:,
            start_date:,
            end_date:,
            description:,
            is_current:
          }
        )

      subject
    end
  end

  describe "remove_experience" do
    subject do
      consumer.remove_experience(
        seeker_id:,
        experience_id:,
        trace_id:
      )
    end

    let(:seeker_id) { SecureRandom.uuid }
    let(:experience_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::ExperienceRemoved::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: experience_id
          }
        )

      subject
    end
  end

  describe "#handle_message" do
    subject { consumer.handle_message(message) }
  end
end
