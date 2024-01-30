class JobFreshnessService < EventConsumer
  FreshnessContext = Struct.new(
    :applicants,
    :employer_name,
    :employment_title,
    :hidden,
    :job_id,
    :recruiter_exists,
    :status,
    keyword_init: true
  )

  JOB_EVENTS = [
    Event::EventTypes::APPLICANT_STATUS_UPDATED,
    Event::EventTypes::JOB_CREATED,
    Event::EventTypes::JOB_UPDATED
  ].freeze

  def self.handled_events
    [
      Events::ApplicantStatusUpdated::V1,
      Events::JobCreated::V1,
      Events::JobUpdated::V1,
      Events::EmployerCreated::V1,
      Events::EmployerUpdated::V1,
      Events::EmployerInviteAccepted::V1,
      Events::DayElapsed::V1
    ].freeze
  end

  def self.call(event:)
    handle_event(event)
  end

  def self.handle_event(event, with_side_effects: false, now: Time.zone.now)
    case event.event_type
    when Event::EventTypes::APPLICANT_STATUS_UPDATED, Event::EventTypes::JOB_CREATED, Event::EventTypes::JOB_UPDATED
      event.aggregate_id

      freshness = new(event.aggregate_id, now:)

      freshness.handle_event(event, with_side_effects:, now:)
    when Event::EventTypes::EMPLOYER_CREATED, Event::EventTypes::EMPLOYER_UPDATED
      eid = event.aggregate_id

      JobFreshnessEmployerJob
        .find_or_initialize_by(employer_id: eid)
        .update!(
          name: event.data[:name],
          recruiter_exists: false
        )
    when Event::EventTypes::EMPLOYER_INVITE_ACCEPTED
      eid = event.aggregate_id

      ej = JobFreshnessEmployerJob.find_by!(employer_id: eid)
      ej.update!(recruiter_exists: true)
      ej.jobs.each do |job_id|
        new(job_id).handle_event(event, with_side_effects:, now:)
      end
    when Event::EventTypes::DAY_ELAPSED
      JobFreshnessContext.pluck(:job_id).each do |job_id|
        new(job_id).handle_event(event, with_side_effects:, now:)
      end
    end

    true
  end

  def initialize(job_id, now: Time.zone.now)
    super()
    @job_id = job_id
    @now = now
  end

  def get
    freshness_context
  end

  def handle_event(event, with_side_effects: false, now: Time.zone.now)
    @now = now

    case event.event_type
    when Event::EventTypes::APPLICANT_STATUS_UPDATED
      applicant_status_updated(event)
    when Event::EventTypes::DAY_ELAPSED
      day_elapsed(event)
    when Event::EventTypes::EMPLOYER_INVITE_ACCEPTED
      employer_invite_accepted(event)
    when Event::EventTypes::JOB_CREATED
      job_create_update(event)
    when Event::EventTypes::JOB_UPDATED
      job_create_update(event)
    else
      return
    end

    freshness_context.status = recruiter_exists? && !hidden? && !any_ignored?(event.occurred_at) ? "fresh" : "stale"
    freshness_context.save!

    return unless with_side_effects

    last_freshness = JobFreshness.where(job_id: freshness_context.job_id).last_created

    return if last_freshness && last_freshness.status == freshness_context.status

    JobFreshness.create!(
      job_id: freshness_context.job_id,
      status: freshness_context.status,
      employer_name: freshness_context.employer_name,
      employment_title: freshness_context.employment_title,
      occurred_at: event.occurred_at
    )
  end

  private

  def any_ignored?(reference_time)
    freshness_context.applicants.any? do |_, applicant|
      reference_time - Time.zone.parse(applicant["last_updated_at"]) > 1.week && applicant["status"] == "new"
    end
  end

  def day_elapsed(event); end

  def hidden?
    freshness_context.hidden
  end

  def recruiter_exists?
    freshness_context.recruiter_exists
  end

  def applicant_status_updated(event)
    freshness_context.applicants[event.data.fetch(:applicant_id)] = {
      "last_updated_at" => event.occurred_at.to_s,
      "status" => event.data.fetch(:status)
    }
  end

  def job_create_update(event)
    @employer_id = event.data[:employer_id]

    ej = employer_job(employer_id)

    unless ej.jobs.include?(job_id)
      ej.jobs << job_id
      ej.save!
    end

    freshness_context.job_id = event.aggregate_id
    freshness_context.hidden = event.data[:hide_job]
    freshness_context.employment_title = event.data[:employment_title]

    freshness_context.recruiter_exists = employer_job(employer_id)[:recruiter_exists]
    freshness_context.employer_name = employer_job(employer_id)[:name]
  end

  def employer_invite_accepted(_event)
    freshness_context.recruiter_exists = true
  end

  def job_events
    @job_events ||= Event.where(aggregate_id: Job.pluck(:id))
  end

  def freshness_context
    @freshness_context ||= JobFreshnessContext.find_by(job_id:)

    return @freshness_context if @freshness_context

    @freshness_context = JobFreshnessContext.create!(
      job_id:,
      status: "fresh",
      applicants: {},
      employer_name: "",
      employment_title: "",
      hidden: false,
      recruiter_exists: false
    )
  end

  def employer_job(employer_id)
    JobFreshnessEmployerJob.find_by!(employer_id:)
  end

  attr_reader :employer_id, :job_id, :now
end
