require 'rails_helper'

RSpec.describe Seekers::StoriesService do
  include_context "event emitter"

  let(:seeker) { create(:seeker) }

  describe "#create" do
    subject { described_class.new(seeker).create(prompt:, response:) }

    let(:prompt) { "This is a prompt" }
    let(:response) { "This is a response" }

    it "creates a story" do
      expect { subject }.to change(Story, :count).by(1)
    end

    it "publishes an event" do
      expect(Events::StoryCreated::Data::V1).to receive(:new).with(
        id: kind_of(String),
        prompt: "This is a prompt",
        response: "This is a response"
      ).and_call_original

      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::StoryCreated::V1,
        seeker_id: seeker.id,
        data: kind_of(Events::StoryCreated::Data::V1)
      ).and_call_original

      subject
    end
  end

  describe "#update" do
    subject { described_class.new(seeker).update(story:, prompt:, response:) }

    let(:story) { create(:story, seeker:) }
    let(:prompt) { "This is a new prompt" }
    let(:response) { "This is a new response" }

    it "updates the story" do
      subject

      expect(story.reload.prompt).to eq("This is a new prompt")
      expect(story.reload.response).to eq("This is a new response")
    end

    it "publishes an event" do
      expect(Events::StoryUpdated::Data::V1).to receive(:new).with(
        id: story.id,
        prompt: "This is a new prompt",
        response: "This is a new response"
      ).and_call_original

      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::StoryUpdated::V1,
        seeker_id: seeker.id,
        data: kind_of(Events::StoryUpdated::Data::V1)
      ).and_call_original

      subject
    end
  end

  describe "#destroy" do
    subject { described_class.new(seeker).destroy(story:) }

    let!(:story) { create(:story, seeker:) }

    it "deletes the story" do
      expect { subject }.to change(Story, :count).by(-1)
    end

    it "publishes an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::StoryDestroyed::V1,
        seeker_id: seeker.id,
        data: Events::StoryDestroyed::Data::V1.new(
          id: story.id
        )
      ).and_call_original

      subject
    end
  end
end
