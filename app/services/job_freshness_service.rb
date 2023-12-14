class JobFreshnessService
  def initialize(job_events=nil, now: Time.now)
    @job_events = job_events
    @now = now
  end

  def get
    job_events.each do |event|
      case event.event_type
      when Event::EventTypes::APPLICANT_STATUS_UPDATED
        applicant_status_updated(event)
      when Event::EventTypes::JOB_CREATED
        job_created(event)
      when Event::EventTypes::JOB_UPDATED
        job_updated(event)
      end
    end

    return "stale" if hidden?
    return "stale" if any_ignored?

    "fresh"
  end

  def self.persist_all
    Job.pluck(:id).each do |job_id|
      events = Event.where(aggregate_id: job_id)

      status = new(events).get

      JobFreshness.create!(
        job_id: job_id,
        status: status
      )
    end
  end

  private

  def any_ignored?
    freshness_context[:applicants].any? do |_, applicant|
      now - applicant[:last_updated_at] > 1.week
    end
  end

  def hidden?
    freshness_context[:hidden]
  end

  def applicant_status_updated(event)
    freshness_context[:applicants][event.data.fetch("applicant_id")] = {
      last_updated_at: event.occurred_at,
    }
  end

  def job_created(event)
    freshness_context[:hidden] = event.data.fetch("hide_job")
  end

  def job_updated(event)
    freshness_context[:hidden] = event.data.fetch("hide_job")
  end

  def job_events
    @job_events ||= Event.where(aggregate_id: Job.pluck(:id))
  end

  def freshness_context
    @freshness_context ||= {
      hidden: {},
      applicants: {}
    }
  end

  attr_reader :job_events, :now
end
