module JobOrders
  class JobOrdersAggregator < MessageConsumer
    def reset_for_replay
      Note.delete_all
      Candidate.delete_all
      JobOrder.delete_all
      Job.delete_all
      Person.delete_all
    end

    on_message ::Events::JobCreated::V3 do |message|
      Job.create!(
        id: message.aggregate.id,
        applicable_for_job_orders: message.data.category == ::Job::Categories::STAFFING,
        employer_name: message.data.employer_name,
        employment_title: message.data.employment_title,
        employer_id: message.data.employer_id
      )
    end

    on_message ::Events::JobUpdated::V2 do |message|
      job = Job.find(message.aggregate.id)

      job.update!(
        employment_title: message.data.employment_title,
        applicable_for_job_orders: message.data.category == ::Job::Categories::STAFFING
      )
    end

    on_message ::Events::PersonAdded::V1 do |message|
      Person.create!(
        id: message.aggregate.id,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number,
        email: message.data.email
      )
    end

    on_message ::Events::BasicInfoAdded::V1 do |message|
      Person.update(
        message.aggregate.id,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number,
        email: message.data.email
      )
    end

    on_message Events::Added::V1, :sync do |message|
      JobOrder.create!(
        id: message.aggregate.id,
        job_orders_jobs_id: message.data.job_id,
        opened_at: message.occurred_at,
        status: JobOrders::ActivatedStatus::NEEDS_ORDER_COUNT,
        order_count: nil,
        recommended_count: 0,
        applicant_count: 0,
        candidate_count: 0,
        screened_count: 0,
        hire_count: 0
      )
    end

    on_message Events::OrderCountAdded::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(
        order_count: message.data.order_count
      )
    end

    on_message Events::CandidateAdded::V3, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      person = Person.find_by(id: message.data.person_id)
      return if person.nil?

      candidate = JobOrders::Candidate.find_or_initialize_by(job_order:, person:)
      candidate.added_at = message.occurred_at if candidate.added_at.blank?
      candidate.recommended_by = message.metadata[:requestor_email] if message.metadata[:requestor_email].present?
      candidate.recommended_at = message.occurred_at if message.metadata[:requestor_id].present?
      candidate.status = CandidateStatus::ADDED
      candidate.save!

      update_job_order_counts(job_order)
    end

    on_message Events::CandidateApplied::V2, :sync do |message|
      candidate = Candidate.find_by!(job_orders_people_id: message.data.person_id, job_orders_job_orders_id: message.aggregate.id)
      candidate.update!(applied_at: message.data.applied_at)
    end

    on_message Events::CandidateRecommended::V2, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      candidate = Candidate.find_by!(job_orders_people_id: message.data.person_id, job_orders_job_orders_id: message.aggregate.id)

      candidate.update!(status: CandidateStatus::RECOMMENDED)
      job_order.candidates.group(:status).count

      update_job_order_counts(job_order)
    end

    on_message Events::CandidateScreened::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      candidate = Candidate.find_by!(job_orders_people_id: message.data.person_id, job_orders_job_orders_id: message.aggregate.id)

      candidate.update!(status: CandidateStatus::SCREENED)
      job_order.candidates.group(:status).count

      update_job_order_counts(job_order)
    end

    on_message Events::CandidateHired::V2, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      candidate = Candidate.find_by!(job_orders_people_id: message.data.person_id, job_orders_job_orders_id: message.aggregate.id)

      candidate.update!(status: CandidateStatus::HIRED)
      update_job_order_counts(job_order)
    end

    on_message Events::CandidateRescinded::V2, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      candidate = Candidate.find_by!(job_orders_people_id: message.data.person_id, job_orders_job_orders_id: message.aggregate.id)

      candidate.update!(status: CandidateStatus::RESCINDED)
      update_job_order_counts(job_order)
    end

    on_message Events::Activated::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(status: ActivatedStatus::OPEN, closed_at: nil)
    end

    on_message Events::Stalled::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(status: message.data.status, closed_at: nil)
    end

    on_message Events::Filled::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(closed_at: message.occurred_at, status: ClosedStatus::FILLED)
    end

    on_message Events::NotFilled::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)
      job_order.update!(closed_at: message.occurred_at, status: ClosedStatus::NOT_FILLED)
    end

    on_message Events::NoteAdded::V1, :sync do |message|
      job_order = JobOrder.find(message.aggregate.id)

      Note.create!(
        id: message.data.note_id,
        job_order:,
        note: message.data.note,
        note_taken_by: message.data.originator,
        note_taken_at: message.occurred_at
      )
    end

    on_message Events::NoteModified::V1, :sync do |message|
      note = Note.find(message.data.note_id)
      note.update!(note: message.data.note)
    end

    on_message Events::NoteRemoved::V1, :sync do |message|
      Note.find(message.data.note_id).destroy!
    end

    private

    def update_job_order_counts(job_order)
      counts = job_order.candidates.group(:status).count

      job_order.update!(
        screened_count: counts[CandidateStatus::SCREENED] || 0,
        candidate_count: counts[CandidateStatus::ADDED] || 0,
        recommended_count: counts[CandidateStatus::RECOMMENDED] || 0,
        hire_count: counts[CandidateStatus::HIRED] || 0
      )
    end
  end
end
