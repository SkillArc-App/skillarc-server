class StudentsController < ApplicationController
  include Secured
  include TrainingProviderAuth

  before_action :authorize
  before_action :training_provider_authorize

  def index
    training_provider = TrainingProvider.includes(
      programs: {
        seeker_invites: {},
        students: {}
      }
    ).find(training_provider_profile.training_provider_id)

    programs = training_provider.programs.map do |program|
      students = program.students.map do |stp|
        # TODO: 🙀 Horrible code. Refactor this.
        reference = stp.seeker.references.find_by(author_profile: training_provider_profile)

        {
          email: stp.seeker.email,
          firstName: stp.seeker.first_name,
          lastName: stp.seeker.last_name,
          profileId: stp.seeker_id,
          reference: {
            referenceText: reference&.reference_text,
            referenceId: reference&.id
          },
          status: stp.status,
          hiringStatus: stp.seeker&.hiring_status || 'FAIL'
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
