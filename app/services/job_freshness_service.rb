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
    Event::EventTypes::JOB_UPDATED,
  ]

  def self.handle_event(event, with_side_effects: false, now: Time.now)
    if JOB_EVENTS.include?(event.event_type)
      job_id = event.aggregate_id

      freshness = new(event.aggregate_id, now: now)

      freshness.handle_event(event, with_side_effects: with_side_effects, now: now)
    elsif [Event::EventTypes::EMPLOYER_CREATED, Event::EventTypes::EMPLOYER_UPDATED].include?(event.event_type)
      eid = event.aggregate_id

      JobFreshnessEmployerJob
        .find_or_initialize_by(employer_id: eid)
        .update!(
          name: event.data["name"],
          recruiter_exists: false
        )
    elsif event.event_type == Event::EventTypes::EMPLOYER_INVITE_ACCEPTED
      eid = event.aggregate_id

      ej = JobFreshnessEmployerJob.find_by!(employer_id: eid)
      ej.update!(recruiter_exists: true)
      ej.jobs.each do |job_id|
        new(job_id).handle_event(event, with_side_effects: with_side_effects, now: now)
      end
    end

    true
  end

  def initialize(job_id, now: Time.now)
    @job_id = job_id
    @now = now
  end

  def get
    freshness_context
  end

  def handle_event(event, with_side_effects: false, now: Time.now)
    @now = now
    
    case event.event_type
    when Event::EventTypes::APPLICANT_STATUS_UPDATED
      applicant_status_updated(event)
    when Event::EventTypes::EMPLOYER_INVITE_ACCEPTED
      employer_invite_accepted(event)
    when Event::EventTypes::JOB_CREATED
      job_create_update(event)
    when Event::EventTypes::JOB_UPDATED
      job_create_update(event)
    else
      return
    end

    if with_side_effects
      JobFreshness.create!(
        job_id: freshness_context.job_id,
        status: freshness_context.status,
        employer_name: freshness_context.employer_name,
        employment_title: freshness_context.employment_title,
        occurred_at: event.occurred_at
      )
    end
  end

  private

  def any_ignored?
    freshness_context.applicants.any? do |_, applicant|
      now - Time.parse(applicant["last_updated_at"]) > 1.week
    end
  end

  def hidden?
    freshness_context.hidden
  end

  def recruiter_exists?
    freshness_context.recruiter_exists
  end

  def applicant_status_updated(event)
    freshness_context.applicants[event.data.fetch("applicant_id")] = {
      "last_updated_at" => event.occurred_at.to_s,
    }

    freshness_context.status = "stale" if any_ignored?

    freshness_context.save!
  end

  def job_create_update(event)
    @employer_id = event.data["employer_id"]

    ej = employer_job(employer_id)

    unless ej.jobs.include?(job_id)
      ej.jobs << job_id
      ej.save!
    end

    freshness_context.job_id = event.aggregate_id
    freshness_context.hidden = event.data["hide_job"]
    freshness_context.employment_title = event.data["employment_title"]

    freshness_context.recruiter_exists = employer_jobs[employer_id][:recruiter_exists]
    freshness_context.employer_name = employer_jobs[employer_id][:name]

    freshness_context.status = "stale" if hidden?
    freshness_context.status = "stale" if !freshness_context.recruiter_exists

    freshness_context.save!
  end

  def employer_invite_accepted(event)
    freshness_context.recruiter_exists = true
    freshness_context.status = recruiter_exists? && !hidden? && !any_ignored? ? "fresh" : "stale"

    freshness_context.save!
  end

  def job_events
    @job_events ||= Event.where(aggregate_id: Job.pluck(:id))
  end

  def freshness_context
    @freshness_context ||= JobFreshnessContext.find_by(job_id: job_id)

    return @freshness_context if @freshness_context

    @freshness_context = JobFreshnessContext.create!(
      job_id: job_id,
      status: "fresh",
      applicants: {},
      employer_name: "",
      employment_title: "",
      hidden: false,
      recruiter_exists: false
    )
  end

  def employer_jobs
    JobFreshnessEmployerJob.all.each_with_object({}) do |employer_job, hash|
      hash[employer_job.employer_id] = {
        name: employer_job.name,
        recruiter_exists: employer_job.recruiter_exists,
        jobs: Set.new(employer_job.jobs)
      }
    end
  end

  def employer_job(employer_id)
    JobFreshnessEmployerJob.find_by!(employer_id: employer_id)
  end

  attr_reader :employer_id, :job_events, :job_id, :now
end
