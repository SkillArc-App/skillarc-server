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

  def self.handled_events_sync
    [].freeze
  end

  def self.handled_events
    [
      Events::ApplicantStatusUpdated::V2,
      Events::JobCreated::V1,
      Events::JobUpdated::V1,
      Events::EmployerCreated::V1,
      Events::EmployerUpdated::V1,
      Events::EmployerInviteAccepted::V1,
      Events::DayElapsed::V1
    ].freeze
  end

  def self.call(message:)
    handle_event(message)
  end

  def self.handle_event(message, with_side_effects: false, now: Time.zone.now)
    case message.event_schema
    when Events::ApplicantStatusUpdated::V2, Events::JobCreated::V1, Events::JobUpdated::V1
      message.aggregate_id

      freshness = new(message.aggregate_id, now:)

      freshness.handle_event(message, with_side_effects:, now:)
    when Events::EmployerCreated::V1, Events::EmployerUpdated::V1
      eid = message.aggregate_id

      JobFreshnessEmployerJob
        .find_or_initialize_by(employer_id: eid)
        .update!(
          name: message.data[:name],
          recruiter_exists: false
        )
    when Events::EmployerInviteAccepted::V1
      eid = message.aggregate_id

      ej = JobFreshnessEmployerJob.find_by!(employer_id: eid)
      ej.update!(recruiter_exists: true)
      ej.jobs.each do |job_id|
        new(job_id).handle_event(message, with_side_effects:, now:)
      end
    when Events::DayElapsed::V1
      JobFreshnessContext.pluck(:job_id).each do |job_id|
        new(job_id).handle_event(message, with_side_effects:, now:)
      end
    end

    true
  end

  def self.reset_for_replay
    JobFreshness.destroy_all
    JobFreshnessContext.destroy_all
    JobFreshnessEmployerJob.destroy_all
  end

  def initialize(job_id, now: Time.zone.now)
    super()
    @job_id = job_id
    @now = now
  end

  def get
    freshness_context
  end

  def handle_event(message, with_side_effects: false, now: Time.zone.now)
    @now = now

    case message.event_type
    when Event::EventTypes::APPLICANT_STATUS_UPDATED
      applicant_status_updated(message)
    when Event::EventTypes::DAY_ELAPSED
      day_elapsed(message)
    when Event::EventTypes::EMPLOYER_INVITE_ACCEPTED
      employer_invite_accepted(message)
    when Event::EventTypes::JOB_CREATED, Event::EventTypes::JOB_UPDATED
      job_create_update(message)
    else
      return
    end

    freshness_context.status = recruiter_exists? && !hidden? && !any_ignored?(message.occurred_at) ? "fresh" : "stale"
    freshness_context.save!

    return unless with_side_effects

    last_freshness = JobFreshness.where(job_id: freshness_context.job_id).last_created

    return if last_freshness && last_freshness.status == freshness_context.status

    JobFreshness.create!(
      job_id: freshness_context.job_id,
      status: freshness_context.status,
      employer_name: freshness_context.employer_name,
      employment_title: freshness_context.employment_title,
      occurred_at: message.occurred_at
    )
  end

  private

  def any_ignored?(reference_time)
    freshness_context.applicants.any? do |_, applicant|
      reference_time - Time.zone.parse(applicant["last_updated_at"]) > 1.week && applicant["status"] == "new"
    end
  end

  def day_elapsed(message); end

  def hidden?
    freshness_context.hidden
  end

  def recruiter_exists?
    freshness_context.recruiter_exists
  end

  def applicant_status_updated(message)
    freshness_context.applicants[message.data.applicant_id] = {
      "last_updated_at" => message.occurred_at.to_s,
      "status" => message.data.status
    }
  end

  def job_create_update(message)
    @employer_id = message.data[:employer_id]

    ej = employer_job(employer_id)

    unless ej.jobs.include?(job_id)
      ej.jobs << job_id
      ej.save!
    end

    freshness_context.job_id = message.aggregate_id
    freshness_context.hidden = message.data[:hide_job]
    freshness_context.employment_title = message.data[:employment_title]

    freshness_context.recruiter_exists = employer_job(employer_id)[:recruiter_exists]
    freshness_context.employer_name = employer_job(employer_id)[:name]
  end

  def employer_invite_accepted(_message)
    freshness_context.recruiter_exists = true
  end

  def job_events
    @job_events ||= Event.where(aggregate_id: Job.select(:id))
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
