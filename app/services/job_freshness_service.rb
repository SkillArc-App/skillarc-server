class JobFreshnessService < EventConsumer
  FreshnessContext = Struct.new(
    :applicants,
    :employment_title,
    :hidden,
    :job_id,
    :recruiter_exists,
    :status,
    keyword_init:true
  )

  def self.handle_event(event, with_side_effects: false, now: Time.now)
    job_id = event.aggregate_id

    freshnesses[job_id] ||= new

    freshness = freshnesses[job_id]

    freshness.handle_event(event, with_side_effects: with_side_effects, now: now)

    freshnesses
  end

  def initialize(job_events=[], now: Time.now)
    @job_events = job_events
    @now = now

    job_events.each do |event|
      handle_event(event, now: now)
    end
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
        employment_title: freshness_context.employment_title,
      )
    end
  end

  private

  def self.freshnesses
    @freshnesses ||= {}
  end

  def any_ignored?
    freshness_context.applicants.any? do |_, applicant|
      now - applicant[:last_updated_at] > 1.week
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
      last_updated_at: event.occurred_at,
    }

    freshness_context.status = "stale" if any_ignored?
  end

  def employer_invite_accepted(event)
    eid = event.aggregate_id

    employers_with_recruiters << eid

    if employer_id == eid
      freshness_context.recruiter_exists = true

      freshness_context.status = !hidden? && recruiter_exists? && !any_ignored? ? "fresh" : "stale"
    end
  end

  def job_create_update(event)
    @employer_id = event.data["employer_id"]

    freshness_context.job_id = event.aggregate_id
    freshness_context.hidden = event.data["hide_job"]
    freshness_context.employment_title = event.data["employment_title"]

    freshness_context.recruiter_exists = employers_with_recruiters.include?(employer_id)

    freshness_context.status = "stale" if hidden?
    freshness_context.status = "stale" if !freshness_context.recruiter_exists
  end

  def job_events
    @job_events ||= Event.where(aggregate_id: Job.pluck(:id))
  end

  def freshness_context
    @freshness_context ||= FreshnessContext.new(
      applicants: {},
      employment_title: nil,
      hidden: nil,
      job_id: nil,
      recruiter_exists: false,
      status: "fresh"
    )
  end

  def employers_with_recruiters
    @@employers_with_recruiters ||= Set.new
  end

  attr_reader :employer_id, :job_events, :now
end
