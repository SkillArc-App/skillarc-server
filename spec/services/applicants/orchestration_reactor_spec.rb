require 'rails_helper'

RSpec.describe Applicants::OrchestrationReactor do
  describe "applicant screened" do
    subject { described_class.new.handle_message(applicant_screened) }

    include_context "event emitter", false

    let(:applicant_screened) { build(:message, schema: Events::ApplicantScreened::V1, aggregate_id: applicant.id) }
    let(:applicant) { create(:applicant, seeker:, job:) }
    let(:seeker) { create(:seeker, user:) }
    let(:user) { create(:user, first_name: "David", last_name: "Helm", email: "david@skillarc.com", phone_number: "1234567890") }
    let(:job) { create(:job, employer:, employment_title: "Welder") }
    let(:employer) { create(:employer, name: "Skillarc") }

    it "publishes an event" do
      expect_any_instance_of(EventService)
        .to receive(:create!)
        .with(
          job_id: job.id,
          event_schema: Events::ApplicantStatusUpdated::V5,
          data: Events::ApplicantStatusUpdated::Data::V4.new(
            applicant_id: applicant.id,
            applicant_first_name: "David",
            applicant_last_name: "Helm",
            applicant_email: "david@skillarc.com",
            applicant_phone_number: "1234567890",
            seeker_id: seeker.id,
            user_id: user.id,
            job_id: job.id,
            employer_name: "Skillarc",
            employment_title: "Welder",
            status: ApplicantStatus::StatusTypes::NEW,
            reasons: []
          ),
          metadata: Events::ApplicantStatusUpdated::MetaData::V1.new(
            user_id: user.id
          ),
          trace_id: applicant_screened.trace_id,
          version: 5
        )
        .and_call_original

      subject
    end
  end

  describe "screen applicant" do
    subject { described_class.new.handle_message(screen_applicant) }

    include_context "event emitter", false

    let(:screen_applicant) { build(:message, schema: Commands::ScreenApplicant::V1, aggregate_id: applicant.id) }
    let(:applicant) { create(:applicant) }

    it "publishes an event" do
      expect_any_instance_of(EventService)
        .to receive(:create!)
        .with(
          applicant_id: applicant.id,
          event_schema: Events::ApplicantScreened::V1,
          data: Messages::Nothing,
          metadata: Messages::Nothing,
          trace_id: screen_applicant.trace_id,
          version: 1
        )
        .and_call_original

      subject
    end
  end

  describe "seeker applied" do
    subject { described_class.new.handle_message(seeker_applied) }

    include_context "command emitter", false

    let(:seeker_applied) { build(:message, :seeker_applied, data:, aggregate_id: seeker.id) }
    let(:seeker) { create(:seeker) }
    let(:data) do
      Events::SeekerApplied::Data::V1.new(
        seeker_first_name: "Katina",
        seeker_last_name: "Hall",
        seeker_email: "katina@skillarc.com",
        seeker_phone_number: "123-456-7890",
        seeker_id: seeker.id,
        job_id: job.id,
        employer_name: "Skillarc",
        employment_title: "Welder"
      )
    end
    let(:job) { create(:job, employment_title: "Welder") }

    it "creates an applicant" do
      expect { subject }
        .to change(Applicant, :count).by(1)
        .and change(ApplicantStatus, :count).by(1)

      expect(ApplicantStatus.last_created.status).to eq(ApplicantStatus::StatusTypes::NEW)
    end

    it "requests an application screen" do
      expect_any_instance_of(CommandService)
        .to receive(:create!)
        .with(
          applicant_id: be_a(String),
          trace_id: seeker_applied.trace_id,
          command_schema: Commands::ScreenApplicant::V1,
          data: Messages::Nothing
        ).and_call_original

      subject
    end
  end
end
