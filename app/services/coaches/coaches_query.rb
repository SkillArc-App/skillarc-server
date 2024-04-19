module Coaches
  class CoachesQuery
    def self.all_leads
      CoachSeekerContext.leads.map do |csc|
        serialize_seeker_lead(csc)
      end
    end

    def self.all_seekers
      CoachSeekerContext.seekers.includes(:seeker_barriers).map do |csc|
        serialize_coach_seeker_table_context(csc)
      end
    end

    def self.find_context(id)
      csc = CoachSeekerContext.find_by!(context_id: id)

      serialize_coach_seeker_context(csc)
    end

    def self.tasks(coach:, context_id: nil)
      serialize_coach_tasks(coach, context_id)
    end

    def self.all_barriers
      Barrier.all.map do |barrier|
        {
          id: barrier.barrier_id,
          name: barrier.name
        }
      end
    end

    def self.all_coaches
      Coach.all.map do |coach|
        {
          id: coach.coach_id,
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

      def serialize_coach_seeker_table_context(csc)
        {
          id: csc.context_id,
          seeker_id: csc.seeker_id,
          first_name: csc.first_name,
          last_name: csc.last_name,
          email: csc.email,
          phone_number: csc.phone_number,
          last_active_on: csc.last_active_on,
          last_contacted: csc.last_contacted_at || "Never",
          assigned_coach: csc.assigned_coach || 'none',
          certified_by: csc.certified_by,
          barriers: csc.seeker_barriers.map(&:barrier).map { |b| { id: b.barrier_id, name: b.name } }
        }
      end

      def serialize_coach_tasks(coach, context_id)
        reminders = coach.reminders
        reminders = reminders.where(context_id:) if context_id.present?

        reminders.map do |reminder|
          {
            id: reminder.id,
            note: reminder.note,
            state: reminder.state,
            reminder_at: reminder.reminder_at,
            context_id: reminder.context_id
          }
        end
      end

      def serialize_coach_seeker_context(csc)
        {
          id: csc.context_id,
          kind: csc.kind,
          seeker_id: csc.seeker_id,
          first_name: csc.first_name,
          last_name: csc.last_name,
          email: csc.email,
          phone_number: csc.phone_number,
          certified_by: csc.certified_by,
          skill_level: csc.skill_level || 'beginner',
          last_active_on: csc.last_active_on,
          last_contacted: csc.last_contacted_at || "Never",
          assigned_coach: csc.assigned_coach || 'none',
          barriers: csc.seeker_barriers.map(&:barrier).map { |b| { id: b.barrier_id, name: b.name } },
          notes: csc.seeker_notes.map do |note|
            {
              note: note.note,
              note_id: note.note_id,
              note_taken_by: note.note_taken_by,
              date: note.note_taken_at
            }
          end,
          applications: csc.seeker_applications.map do |application|
            {
              status: application.status,
              employer_name: application.employer_name,
              job_id: application.job_id,
              employment_title: application.employment_title
            }
          end,
          job_recommendations: csc.seeker_job_recommendations.map(&:job).map(&:job_id)
        }
      end

      def serialize_seeker_lead(csc)
        {
          id: csc.context_id,
          email: csc.email,
          assigned_coach: csc.assigned_coach || 'none',
          phone_number: csc.phone_number,
          first_name: csc.first_name,
          last_name: csc.last_name,
          lead_captured_at: csc.seeker_captured_at,
          lead_captured_by: csc.lead_captured_by,
          kind: csc.kind,
          status: "new"
        }
      end
    end
  end
end
