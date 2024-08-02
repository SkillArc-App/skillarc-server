module Coaches
  class CoachesQuery
    def self.all_people
      PersonContext.all.map do |person_context|
        serialize_coach_seeker_table_context(person_context)
      end
    end

    def self.find_people(ids)
      PersonContext.where(id: ids).map do |person_context|
        serialize_coach_seeker_table_context(person_context)
      end
    end

    def self.find_person(id)
      person_context = PersonContext.find(id)

      serialize_person_context(person_context)
    end

    def self.tasks(coach:, person_id: nil)
      serialize_coach_tasks(coach, person_id)
    end

    def self.all_coaches
      Coach.all.map do |coach|
        {
          id: coach.id,
          email: coach.email
        }
      end
    end

    def self.all_jobs
      Job.visible.map do |job|
        {
          id: job.job_id,
          employer_name: job.employer_name,
          employment_title: job.employment_title
        }
      end
    end

    class << self
      private

      def serialize_coach_seeker_table_context(person_context)
        {
          id: person_context.id,
          seeker_id: person_context.id,
          first_name: person_context.first_name,
          last_name: person_context.last_name,
          email: person_context.email,
          kind: person_context.kind,
          lead_captured_at: person_context.person_captured_at,
          lead_captured_by: person_context.captured_by,
          phone_number: person_context.phone_number,
          last_active_on: person_context.last_active_on,
          last_contacted: person_context.last_contacted_at || "Never",
          assigned_coach: person_context.assigned_coach || 'none',
          certified_by: person_context.certified_by
        }
      end

      def serialize_coach_tasks(coach, person_id)
        reminders = coach.reminders
        reminders = reminders.where(person_id:) if person_id.present?

        reminders.map do |reminder|
          {
            id: reminder.id,
            note: reminder.note,
            state: reminder.state,
            reminder_at: reminder.reminder_at,
            context_id: reminder.person_id
          }
        end
      end

      def serialize_person_context(person_context)
        {
          **serialize_coach_seeker_table_context(person_context),
          attributes: person_context.person_attributes.map { |a| { name: a.name, id: a.id, attribute_id: a.attribute_id, value: a.values } },
          notes: person_context.notes.map do |note|
            {
              note: note.note,
              note_id: note.id,
              note_taken_by: note.note_taken_by,
              date: note.note_taken_at
            }
          end,
          applications: person_context.applications.map do |application|
            {
              status: application.status,
              employer_name: application.employer_name,
              job_id: application.job_id,
              employment_title: application.employment_title
            }
          end,
          job_recommendations: person_context.job_recommendations.map(&:job).map(&:job_id)
        }
      end
    end
  end
end
