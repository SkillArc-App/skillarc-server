module Jobs
  class JobBlueprint < Blueprinter::Base
    identifier :id

    view :seeker do
      field :employment_title
      field :industry, name: :industries
      field :location
      field :application_status
      field :starting_pay do |job|
        starting_path = job.career_paths.detect { |p| p.order.zero? }
        next nil if starting_path.blank?

        {
          employment_type: starting_path.lower_limit.to_i > 1000 ? "salary" : "hourly",
          upper_limit: starting_path.upper_limit.to_i,
          lower_limit: starting_path.lower_limit.to_i
        }
      end
      field :tags do |job, _options|
        job.job_tags.map { |jt| jt.tag.name }
      end
      field :application_status do |job, options|
        next nil if options[:user].blank?
        next nil if options[:user].seeker.blank?

        applicant = job.applicants.detect { |a| a.seeker_id == options[:user].seeker.id }
        applicant&.status&.status
      end
      field :saved do |job, options|
        next false if options[:user].blank?

        # This will need to extrat into something sensible
        save_events = Event
                      .where(
                        aggregate_id: options[:user].id,
                        event_type: [Event::EventTypes::JOB_SAVED, Event::EventTypes::JOB_UNSAVED]
                      )
                      .map(&:message)
                      .select { |e| e.data[:job_id] == job.id }

        save_events&.sort_by(&:occurred_at)&.last&.event_type == Event::EventTypes::JOB_SAVED || false
      end
      association :employer, blueprint: Employers::EmployerBlueprint
    end
  end
end
