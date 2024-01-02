require 'rails_helper'

RSpec.describe CoachSeekers do
  let(:non_seeker_user_created) { build(:event, :user_created, aggregate_id: "123", data: { email: "f@f.f" }) }
  let(:user_created) { build(:event, :user_created, aggregate_id: user_id, data: { email: "hannah@blocktrainapp.com"}) }
  let(:user_updated) { build(:event, :user_updated, aggregate_id: user_id, data: { first_name: "Hannah", last_name: "Block", phone_number: "1234567890" }) }
  let(:profile_created) { build(:event, :profile_created, aggregate_id: user_id, data: { id: profile_id }) }
  let(:note_added) { build(:event, :note_added, aggregate_id: profile_id, data: { note: "This is a note" }, occurred_at: Time.utc(2020, 1, 1)) }
  let(:skill_level_updated) { build(:event, :skill_level_updated, aggregate_id: profile_id, data: { skill_level: "advanced" }, occurred_at: Time.utc(2020, 1, 1)) }
  let(:coach_assigned) { build(:event, :coach_assigned, aggregate_id: profile_id, data: { coach_id: "123", email: "coach@blocktrainapp.com" }, occurred_at: Time.utc(2020, 1, 1)) }

  let(:user_id) { "9f769972-c41c-4b58-a056-bffb714ea24d" }
  let(:profile_id) { "75372772-49dc-4884-b4ae-1d408e030aa4" }

  before do
    described_class.handle_event(non_seeker_user_created)
    described_class.handle_event(user_created)
    described_class.handle_event(user_updated)
    described_class.handle_event(profile_created)
    described_class.handle_event(note_added)
    described_class.handle_event(skill_level_updated)
    described_class.handle_event(coach_assigned)
  end

  describe ".all" do
    subject { described_class.all }

    it "returns all profiles" do
      expected_profile = {
        seekerId: profile_id,
        firstName: "Hannah",
        lastName: "Block",
        email: "hannah@blocktrainapp.com",
        phoneNumber: "1234567890",
        skillLevel: 'advanced',
        lastActiveOn: profile_created.occurred_at,
        lastContacted: note_added.occurred_at,
        assignedCoach: '123',
        barriers: [],
        notes: [
          {
            note: "This is a note",
            date: Time.utc(2020, 1, 1)
          }
        ].as_json,
        stage: 'profile_created',
      }        

      expect(subject.first).to eq(expected_profile)
    end
  end

  describe ".find" do
    subject { described_class.find(profile_id) }

    it "returns the profile" do
      expected_profile = {
        seekerId: profile_id,
        firstName: "Hannah",
        lastName: "Block",
        email: "hannah@blocktrainapp.com",
        phoneNumber: "1234567890",
        skillLevel: 'advanced',
        lastActiveOn: profile_created.occurred_at,
        lastContacted: note_added.occurred_at,
        assignedCoach: '123',
        barriers: [],
        notes: [
          {
            note: "This is a note",
            date: Time.utc(2020, 1, 1)
          }
        ].as_json,
        stage: 'profile_created',
      }        

      expect(subject).to eq(expected_profile)
    end
  end

  describe ".add_note" do
    subject { described_class.add_note(profile_id, "This is a new note", now: now) }
    let(:now) { Time.new(2020, 1, 1) }

    it "creates an event" do
      expect(Resque).to receive(:enqueue).with(
        CreateEventJob,
        event_type: Event::EventTypes::NOTE_ADDED,
        aggregate_id: profile_id,
        data: {
          note: "This is a new note"
        },
        metadata: {},
        occurred_at: now
      )

      subject
    end
  end

  describe ".assign_coach" do
    subject { described_class.assign_coach(profile_id, "123", "coach@blocktrainapp.com", now: now) }
    let(:now) { Time.new(2020, 1, 1) }

    it "creates an event" do
      expect(Resque).to receive(:enqueue).with(
        CreateEventJob,
        event_type: Event::EventTypes::COACH_ASSIGNED,
        aggregate_id: profile_id,
        data: {
          coach_id: "123",
          email: "coach@blocktrainapp.com"
        },
        metadata: {},
        occurred_at: now
      )

      subject
    end
  end

  describe ".update_skill_level" do
    subject { described_class.update_skill_level(profile_id, "advanced", now: now) }

    let(:now) { Time.new(2020, 1, 1) }

    it "creates an event" do
      expect(Resque).to receive(:enqueue).with(
        CreateEventJob,
        event_type: Event::EventTypes::SKILL_LEVEL_UPDATED,
        aggregate_id: profile_id,
        data: {
          skill_level: "advanced"
        },
        metadata: {},
        occurred_at: now
      )

      subject
    end
  end
end