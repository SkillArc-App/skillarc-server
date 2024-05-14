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
        expect(job.id).to eq(message.aggregate.id)
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
        expect(job.employment_title).to eq(message.data.employment_title)
      end
    end

    context "when the message is seeker created" do
      let(:message) do
        build(
          :message,
          schema: Events::SeekerCreated::V1,
          data: {
            user_id: SecureRandom.uuid
          }
        )
      end

      it "creates a seeker record" do
        expect { subject }.to change(JobOrders::Seeker, :count).from(0).to(1)

        seeker = JobOrders::Seeker.take(1).first
        expect(seeker.id).to eq(message.aggregate.id)
      end
    end

    context "when the message is basic info added" do
      let(:message) do
        build(
          :message,
          schema: Events::BasicInfoAdded::V1,
          aggregate_id: seeker.id,
          data: {
            user_id: SecureRandom.uuid,
            first_name: "Chris",
            last_name: "Brauns",
            phone_number: "+1333333333",
            date_of_birth: nil
          }
        )
      end

      let!(:seeker) { create(:job_orders__seeker) }

      it "creates a seeker record" do
        subject

        seeker.reload
        expect(seeker.first_name).to eq(message.data.first_name)
        expect(seeker.last_name).to eq(message.data.last_name)
        expect(seeker.phone_number).to eq(message.data.phone_number)
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
        expect(job_order.id).to eq(message.aggregate.id)
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
          schema: Events::JobOrderCandidateAdded::V1,
          aggregate_id: job_order.id,
          data: {
            seeker_id: seeker.id
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, candidate_count: 0) }
      let!(:seeker) { create(:job_orders__seeker) }

      it "creates a candidate record and updates the job order" do
        expect { subject }.to change(JobOrders::Candidate, :count).from(0).to(1)

        candidate = JobOrders::Candidate.take(1).first
        expect(candidate.status).to eq(JobOrders::CandidateStatus::ADDED)
        expect(candidate.seeker).to eq(seeker)
        expect(candidate.job_order).to eq(job_order)

        job_order.reload
        expect(job_order.candidate_count).to eq(1)
      end
    end

    context "when the message is job order candidate recommended" do
      let(:message) do
        build(
          :message,
          schema: Events::JobOrderCandidateRecommended::V1,
          aggregate_id: job_order.id,
          data: {
            seeker_id: seeker.id
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, candidate_count: 1, recommended_count: 0) }
      let!(:candidate) { create(:job_orders__candidate, seeker:, job_order:, status: JobOrders::CandidateStatus::ADDED) }
      let!(:seeker) { create(:job_orders__seeker) }

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
          schema: Events::JobOrderCandidateHired::V1,
          aggregate_id: job_order.id,
          data: {
            seeker_id: seeker.id
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, recommended_count: 1, hire_count: 0) }
      let!(:candidate) { create(:job_orders__candidate, seeker:, job_order:, status: JobOrders::CandidateStatus::ADDED) }
      let!(:seeker) { create(:job_orders__seeker) }

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
          schema: Events::JobOrderCandidateRescinded::V1,
          aggregate_id: job_order.id,
          data: {
            seeker_id: seeker.id
          }
        )
      end

      let!(:job_order) { create(:job_orders__job_order, hire_count: 1) }
      let!(:candidate) { create(:job_orders__candidate, seeker:, job_order:, status: JobOrders::CandidateStatus::ADDED) }
      let!(:seeker) { create(:job_orders__seeker) }

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

      let!(:job_order) { create(:job_orders__job_order) }

      it "updates the job order" do
        subject

        job_order.reload
        expect(job_order.status).to eq(JobOrders::ActivatedStatus::OPEN)
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

      let!(:job_order) { create(:job_orders__job_order) }

      it "updates the job order" do
        subject

        job_order.reload
        expect(job_order.status).to eq(JobOrders::StalledStatus::WAITING_ON_EMPLOYER)
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
      end
    end
  end
end
