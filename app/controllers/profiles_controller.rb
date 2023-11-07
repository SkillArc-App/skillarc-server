class ProfilesController < ApplicationController
  include Secured
  include Admin
  include Cereal

  before_action :authorize, only: [:index]
  before_action :admin_authorize, only: [:index]

  def index
    # Profile all with nested include of user and seeker_training_providers

    ps = Profile.includes(user: { seeker_training_providers: [:training_provider, :program] }).all.order(created_at: :desc).map do |p|
      {
        **p.as_json,
        user: {
          **p.user.as_json,
          SeekerTrainingProvider: p.user.seeker_training_providers.map do |stp|
            {
              **stp.as_json,
              trainingProvider: stp.training_provider.as_json,
              program: stp.program.as_json
            }
          end.as_json
        }
      }
    end

    render json: ps
  end

  def show
    profile = Profile.includes(profile_skills: :master_skill).find(params[:id])

    industry_interests = profile.user.onboarding_session.responses.dig("opportunityInterests", "response")

    render json: {
      **profile.as_json,
      desired_outcomes: [],
      educationExperiences: profile.education_experiences,
      hiringStatus: profile.hiring_status,
      industryInterests: industry_interests,
      otherExperiences: profile.other_experiences,
      personalExperience: profile.personal_experiences,
      profileCertifications: [],
      professionalInterests: [],
      profileSkills: profile.profile_skills.map do |ps|
        {
          **ps.as_json,
          masterSkill: ps.master_skill.as_json
        }
      end,
      programs: [],
      reference: [],
      skills: [],
      stories: profile.stories,
      missingProfileItems: ProfileCompleteness.new(profile).status.missing,
      user: {
        **profile.user.as_json,
        SeekerTrainingProvider: profile.user.seeker_training_providers.map do |stp|
          {
            **stp.as_json,
            trainingProvider: stp.training_provider.as_json,
            program: stp.program.as_json
          }
        end.as_json
      }
    }
  end
end
