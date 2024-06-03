module JobOrders
  class JobOrdersAggregator < MessageConsumer
    def reset_for_replay
      Note.delete_all
      Candidate.delete_all
      JobOrder.delete_all
      Job.delete_all
      Seeker.delete_all
    end

    on_message Events::JobCreated::V3 do |message|
      Job.create!(
        id: message.aggregate.id,
        applicable_for_job_orders: message.data.category == ::Job::Categories::STAFFING,
        employer_name: message.data.employer_name,
        employment_title: message.data.employment_title,
        employer_id: message.data.employer_id
      )
    end

    on_message Events::JobUpdated::V2 do |message|
      job = Job.find(message.aggregate.id)

      job.update!(
        employment_title: message.data.employment_title,
        applicable_for_job_orders: message.data.category == ::Job::Categories::STAFFING
      )
    end

    on_message Events::PersonAdded::V1 do |message|
      Seeker.create!(
        id: message.aggregate.id,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number,
        email: message.data.email
      )
    end

    on_message Events::BasicInfoAdded::V1 do |message|
      Seeker.update(
        message.aggregate.id,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number,
        email: message.data.email
      )
    end

    on_message Events::JobOrderAdded::V1, :sync do |message|
      JobOrder.create!(
        id: message.aggregate.id,
        job_orders_jobs_id: message.data.job_id,
        opened_at: message.occurred_at,
        status: JobOrders::ActivatedStatus::NEEDS_ORDER_COUNT,
        order_count: nil,
        recommended_count: 0,
        applicant_count: 0,
        candidate_count: 0,
        hire_count: 0
      )
    end

    on_message Events::JobOrderOrderCountAdded::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(
        order_count: message.data.order_count
      )
    end

    on_message Events::JobOrderCandidateAdded::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      seeker = Seeker.find_by(id: message.data.seeker_id)
      return if seeker.nil?

      candidate = JobOrders::Candidate.find_or_initialize_by(job_order:, seeker:)
      candidate.added_at = message.occurred_at
      candidate.status = CandidateStatus::ADDED
      candidate.save!

      update_job_order_counts(job_order)
    end

    on_message Events::JobOrderCandidateApplied::V1, :sync do |message|
      candidate = Candidate.find_by!(job_orders_seekers_id: message.data.seeker_id, job_orders_job_orders_id: message.aggregate.id)
      candidate.update!(applied_at: message.data.applied_at)
    end

    on_message Events::JobOrderCandidateRecommended::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      candidate = Candidate.find_by!(job_orders_seekers_id: message.data.seeker_id, job_orders_job_orders_id: message.aggregate.id)

      candidate.update!(status: CandidateStatus::RECOMMENDED)
      job_order.candidates.group(:status).count

      update_job_order_counts(job_order)
    end

    on_message Events::JobOrderCandidateHired::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      candidate = Candidate.find_by!(job_orders_seekers_id: message.data.seeker_id, job_orders_job_orders_id: message.aggregate.id)

      candidate.update!(status: CandidateStatus::HIRED)
      update_job_order_counts(job_order)
    end

    on_message Events::JobOrderCandidateRescinded::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      candidate = Candidate.find_by!(job_orders_seekers_id: message.data.seeker_id, job_orders_job_orders_id: message.aggregate.id)

      candidate.update!(status: CandidateStatus::RESCINDED)
      update_job_order_counts(job_order)
    end

    on_message Events::JobOrderActivated::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(status: ActivatedStatus::OPEN, closed_at: nil)
    end

    on_message Events::JobOrderStalled::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(status: message.data.status, closed_at: nil)
    end

    on_message Events::JobOrderFilled::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(closed_at: message.occurred_at, status: ClosedStatus::FILLED)
    end

    on_message Events::JobOrderNotFilled::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(closed_at: message.occurred_at, status: ClosedStatus::NOT_FILLED)
    end

    on_message Events::JobOrderNoteAdded::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)

      Note.create!(
        id: message.data.note_id,
        job_order:,
        note: message.data.note,
        note_taken_by: message.data.originator,
        note_taken_at: message.occurred_at
      )
    end

    on_message Events::JobOrderNoteModified::V1, :sync do |message|
      note = Note.find(message.data.note_id)
      note.update!(note: message.data.note)
    end

    on_message Events::JobOrderNoteRemoved::V1, :sync do |message|
      Note.find(message.data.note_id).destroy!
    end

    private

    def update_job_order_counts(job_order)
      counts = job_order.candidates.group(:status).count

      job_order.update!(
        candidate_count: counts[JobOrders::CandidateStatus::ADDED] || 0,
        recommended_count: counts[JobOrders::CandidateStatus::RECOMMENDED] || 0,
        hire_count: counts[JobOrders::CandidateStatus::HIRED] || 0
      )
    end
  end
end
