class StudentsController < ApplicationController
  include Secured
  include TrainingProviderAuth

  before_action :authorize
  before_action :training_provider_authorize

  def index
    training_provider = TrainingProvider.includes(
      programs: {
        seeker_invites: {},
        students: {
          program_statuses: {},
          user: {
            profile: {
              applicants: :applicant_statuses,
              references: {}
            }
          }
        }
      }
    ).find_by(id: training_provider_profile.training_provider_id)

    programs = training_provider.programs.map do |program|
      students = program.students.map do |stp|
        next if stp.user.seeker.blank?

        # TODO: 🙀 Horrible code. Refactor this.
        reference = stp.user.seeker.references.find_by(author_profile: training_provider_profile)

        {
          email: stp.user.email,
          firstName: stp.user.first_name,
          lastName: stp.user.last_name,
          profileId: stp.user.seeker&.id,
          reference: {
            referenceText: reference&.reference_text,
            referenceId: reference&.id
          },
          status: stp.program_statuses.order(created_at: :desc).first&.status || 'Enrolled',
          hiringStatus: stp.user.seeker&.hiring_status || 'FAIL'
        }
      end.compact

      invitees = program.seeker_invites.map do |invite|
        {
          email: invite.email,
          firstName: invite.first_name,
          lastName: invite.last_name,
          profileId: nil,
          reference: {},
          status: 'No Profile',
          hiringStatus: 'No Profile'
        }
      end

      {
        programName: program.name,
        programId: program.id,
        students: students.concat(invitees)
      }
    end

    render json: programs
  end
end
