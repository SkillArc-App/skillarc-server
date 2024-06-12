require 'rails_helper'

RSpec.describe JobOrders::JobOrdersAggregator do
  it_behaves_like "a replayable message consumer"

  describe "#handle_message" do
    subject { instance.handle_message(message) }

    let(:instance) { described_class.new }

    context "when the message is job created" do
      let(:message) do
        build(
          :message,
          schema: Events::JobCreated::V3,
          data: {
            category: Job::Categories::MARKETPLACE,
            employment_title: "A title",
            employer_name: "An employer",
            employer_id: SecureRandom.uuid,
            benefits_description: "Bad benifits",
            responsibilities_description: nil,
            location: "Columbus Ohio",
            employment_type: Job::EmploymentTypes::FULLTIME,
            hide_job: false
          }
        )
      end

      it "creates a job record" do
        expect { subject }.to change(JobOrders::Job, :count).from(0).to(1)

        job = JobOrders::Job.take(1).first
        expect(job.id).to eq(message.stream.id)
        expect(job.applicable_for_job_orders).to eq(false)
        expect(job.employer_name).to eq(message.data.employer_name)
        expect(job.employment_title).to eq(message.data.employment_title)
        expect(job.employer_id).to eq(message.data.employer_id)
      end
    end

    context "when the message is job updated" do
      let(:message) do
        build(
          :message,
          schema: Events::JobUpdated::V2,
          aggregate_id: job.id,
          data: {
            category: Job::Categories::STAFFING,
            employment_title: "Another title",
            employment_type: Job::EmploymentTypes::PARTTIME,
            hide_job: false
          }
        )
      end

      let!(:job) { create(:job_orders__job) }

      it "updates a job record" do
        subject

        job.reload
        expect(job.applicable_for_job_orders).to eq(true)
        expect(job.employment_title).to eq(message.data.employment_title)
      end
    end

    context "when the message is person added" do
      let(:message) do
        build(
          :message,
          schema: Events::PersonAdded::V1,
          data: {
            first_name: "King",
            last_name: "David",
            date_of_birth: "10/09/1990",
            email: "A@B.c",
            phone_number: "4444444444"
          }
        )
      end

      it "creates a person record" do
        expect { subject }.to change(JobOrders::Person, :count).from(0).to(1)

        person = JobOrders::Person.take(1).first
        expect(person.id).to eq(message.stream.id)
        expect(person.first_name).to eq(message.data.first_name)
        expect(person.last_name).to eq(message.data.last_name)
        expect(person.email).to eq(message.data.email)
        expect(person.phone_number).to eq(message.data.phone_number)
      end
    end

    context "when the message is basic info added" do
      let(:message) do
        build(
          :message,
          schema: Events::BasicInfoAdded::V1,
          aggregate_id: person.id,
          data: {
            first_name: "Chris",
            last_name: "Brauns",
            phone_number: "+1333333333",
            email: "top@dawg.com"
          }
        )
      end

      let!(:person) { create(:job_orders__person) }

      it "updates a person record" do
        subject

        person.reload
        expect(person.first_name).to eq(message.data.first_name)
        expect(person.last_name).to eq(message.data.last_name)
        expect(person.phone_number).to eq(message.data.phone_number)
        expect(person.email).to eq(message.data.email)
      end
    end

    context "when the message is job order added" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderAdded::V1,
          data: {
            job_id: job.id
          },
          occurred_at: Time.zone.local(2000, 10, 10)
        )
      end

      let(:job) { create(:job_orders__job) }

      it "creates a job order record" do
        expect { subject }.to change(JobOrders::JobOrder, :count).from(0).to(1)

        job_order = JobOrders::JobOrder.take(1).first
        expect(job_order.id).to eq(message.stream.id)
        expect(job_order.status).to eq(JobOrders::ActivatedStatus::NEEDS_ORDER_COUNT)
        expect(job_order.opened_at).to eq(message.occurred_at)
        expect(job_order.job).to eq(job)
        expect(job_order.order_count).to eq(nil)
        expect(job_order.recommended_count).to eq(0)
        expect(job_order.applicant_count).to eq(0)
        expect(job_order.candidate_count).to eq(0)
        expect(job_order.hire_count).to eq(0)
      end
    end

    context "when the message is job order order count added" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderOrderCountAdded::V1,
          aggregate_id: job_order.id,
          data: {
            order_count: 5
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order) }

      it "updates a job order record" do
        subject

        job_order.reload
        expect(job_order.order_count).to eq(message.data.order_count)
      end
    end

    context "when the message is job order candidate added" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderCandidateAdded::V2,
          aggregate_id: job_order.id,
          data: {
            person_id: person.id
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, candidate_count: 0) }
      let!(:person) { create(:job_orders__person) }
      let(:status) { JobOrders::ActivatedStatus::ADDED }

      it "creates a candidate record and updates the job order" do
        expect { subject }.to change(JobOrders::Candidate, :count).from(0).to(1)

        candidate = JobOrders::Candidate.take(1).first
        expect(candidate.status).to eq(JobOrders::CandidateStatus::ADDED)
        expect(candidate.person).to eq(person)
        expect(candidate.job_order).to eq(job_order)
        expect(candidate.added_at).to eq(message.occurred_at)

        job_order.reload
        expect(job_order.candidate_count).to eq(1)
      end

      context "when the candidate already exists" do
        let!(:candidate) { create(:job_orders__candidate, person:, job_order:, status: JobOrders::CandidateStatus::RESCINDED) }

        it "changes the status to added" do
          expect { subject }
            .to change { candidate.reload.status }
            .from(JobOrders::CandidateStatus::RESCINDED).to(JobOrders::CandidateStatus::ADDED)

          expect(job_order.reload.candidate_count).to eq(1)
        end
      end

      context "when a candidate record is added multiple times" do
        it "creates a candidate record and updates the job order once" do
          expect do
            instance.handle_message(message)
            instance.handle_message(message)
          end.to change(JobOrders::Candidate, :count).from(0).to(1)

          candidate = JobOrders::Candidate.take(1).first
          expect(candidate.status).to eq(JobOrders::CandidateStatus::ADDED)
          expect(candidate.person).to eq(person)
          expect(candidate.job_order).to eq(job_order)

          job_order.reload
          expect(job_order.candidate_count).to eq(1)
        end
      end
    end

    context "when the message is job order candidate applied" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderCandidateApplied::V2,
          aggregate_id: job_order.id,
          data: {
            person_id: person.id,
            applied_at: Time.zone.local(2024, 1, 1)
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, candidate_count: 1, recommended_count: 0) }
      let!(:candidate) { create(:job_orders__candidate, person:, job_order:, status: JobOrders::CandidateStatus::ADDED) }
      let!(:person) { create(:job_orders__person) }

      it "updates a candidate record and updates the job order" do
        subject

        candidate.reload
        expect(candidate.applied_at).to eq(message.data.applied_at)
      end
    end

    context "when the message is job order candidate recommended" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderCandidateRecommended::V2,
          aggregate_id: job_order.id,
          data: {
            person_id: person.id
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, candidate_count: 1, recommended_count: 0) }
      let!(:candidate) { create(:job_orders__candidate, person:, job_order:, status: JobOrders::CandidateStatus::ADDED) }
      let!(:person) { create(:job_orders__person) }

      it "updates a candidate record and updates the job order" do
        subject

        candidate.reload
        expect(candidate.status).to eq(JobOrders::CandidateStatus::RECOMMENDED)

        job_order.reload
        expect(job_order.candidate_count).to eq(0)
        expect(job_order.recommended_count).to eq(1)
      end
    end

    context "when the message is job order candidate hired" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderCandidateHired::V2,
          aggregate_id: job_order.id,
          data: {
            person_id: person.id
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, recommended_count: 1, hire_count: 0) }
      let!(:candidate) { create(:job_orders__candidate, person:, job_order:, status: JobOrders::CandidateStatus::ADDED) }
      let!(:person) { create(:job_orders__person) }

      it "updates a candidate record and updates the job order" do
        subject

        candidate.reload
        expect(candidate.status).to eq(JobOrders::CandidateStatus::HIRED)

        job_order.reload
        expect(job_order.recommended_count).to eq(0)
        expect(job_order.hire_count).to eq(1)
      end
    end

    context "when the message is job order candidate rescinded" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderCandidateRescinded::V2,
          aggregate_id: job_order.id,
          data: {
            person_id: person.id
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, hire_count: 1) }
      let!(:candidate) { create(:job_orders__candidate, person:, job_order:, status: JobOrders::CandidateStatus::ADDED) }
      let!(:person) { create(:job_orders__person) }

      it "updates a candidate record and updates the job order" do
        subject

        candidate.reload
        expect(candidate.status).to eq(JobOrders::CandidateStatus::RESCINDED)

        job_order.reload
        expect(job_order.hire_count).to eq(0)
      end
    end

    context "when the message is job order activated" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderActivated::V1,
          aggregate_id: job_order.id,
          data: Messages::Nothing
        )
      end

      let!(:job_order) { create(:job_orders__job_order, closed_at: Time.utc(2024, 1, 1)) }

      it "updates the job order" do
        subject

        job_order.reload
        expect(job_order.status).to eq(JobOrders::ActivatedStatus::OPEN)
        expect(job_order.closed_at).to eq(nil)
      end
    end

    context "when the message is job order stalled" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderStalled::V1,
          aggregate_id: job_order.id,
          data: {
            status: JobOrders::StalledStatus::WAITING_ON_EMPLOYER
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, closed_at: Time.utc(2024, 1, 1)) }

      it "updates the job order" do
        subject

        job_order.reload
        expect(job_order.status).to eq(JobOrders::StalledStatus::WAITING_ON_EMPLOYER)
        expect(job_order.closed_at).to eq(nil)
      end
    end

    context "when the message is job order filled" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderFilled::V1,
          aggregate_id: job_order.id,
          data: Messages::Nothing
        )
      end

      let!(:job_order) { create(:job_orders__job_order) }

      it "updates the job order" do
        subject

        job_order.reload
        expect(job_order.status).to eq(JobOrders::ClosedStatus::FILLED)
        expect(job_order.closed_at).to eq(message.occurred_at)
      end
    end

    context "when the message is job order not filled" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderNotFilled::V1,
          aggregate_id: job_order.id,
          data: Messages::Nothing
        )
      end

      let!(:job_order) { create(:job_orders__job_order) }

      it "updates the job order" do
        subject

        job_order.reload
        expect(job_order.status).to eq(JobOrders::ClosedStatus::NOT_FILLED)
        expect(job_order.closed_at).to eq(message.occurred_at)
      end
    end

    context "when the message is job order note added" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderNoteAdded::V1,
          aggregate_id: job_order.id,
          data: {
            originator: "john@skillarc.com",
            note_id: SecureRandom.uuid,
            note: "This is a note"
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order) }

      it "updates the job order" do
        expect { subject }.to change(JobOrders::Note, :count).from(0).to(1)

        note = JobOrders::Note.take(1).first
        expect(note.id).to eq(message.data.note_id)
        expect(note.note).to eq(message.data.note)
        expect(note.note_taken_by).to eq(message.data.originator)
        expect(note.note_taken_at).to eq(message.occurred_at)
      end
    end

    context "when the message is job order note modified" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderNoteModified::V1,
          aggregate_id: job_order.id,
          data: {
            originator: "john@skillarc.com",
            note: "This is a new note",
            note_id: note.id
          }
        )
      end

      let(:job_order) { create(:job_orders__job_order) }
      let!(:note) { create(:job_orders__note, job_order:) }

      it "updates the job order note" do
        subject

        note.reload
        expect(note.note).to eq(message.data.note)
      end
    end

    context "when the message is job order note removed" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderNoteRemoved::V1,
          aggregate_id: job_order.id,
          data: {
            originator: "john@skillarc.com",
            note_id: note.id
          }
        )
      end

      let(:job_order) { create(:job_orders__job_order) }
      let!(:note) { create(:job_orders__note, job_order:) }

      it "delete the job order note" do
        expect { subject }.to change(JobOrders::Note, :count).from(1).to(0)
      end
    end
  end
end
