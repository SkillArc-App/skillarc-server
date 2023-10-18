class OneUserController < ApplicationController
  include Secured
  include Cereal

  before_action :authorize, only: [:index]

  def index
    user_ret = deep_transform_keys(current_user.slice(:id, :name, :email, :first_name, :last_name, :zip_code, :phone_number)) { |key| to_camel_case(key) }
    os_ret = (current_user.onboarding_session || {}).slice(:id, :started_at, :completed_at, :responses)

    profile = current_user.profile&.slice(
      :id,
      :image,
      :status,
      :bio
    ) || {}

    render json: {
      **user_ret,
      onboardingSession: os_ret,
      userRoles: current_user.user_roles.map do |ur|
        {
          **ur.as_json,
          role: ur.role.as_json
        }
      end || [],
      profile: {
        **profile,
        educationExperiences: current_user.profile&.education_experiences || [],
        desiredOutcomes: [],
        professionalInterests: [],
        profileCertifications: [],
        profileSkills: current_user.profile&.profile_skills&.map do |ps|
          {
            **ps.as_json,
            masterSkill: ps.master_skill.as_json
          }
        end || [],
        stories: current_user.profile&.stories || [],
        otherExperiences: current_user.profile&.other_experiences || [],
        personalExperience: current_user.profile&.personal_experiences || []
      },
      recruiter: current_user.recruiter&.as_json,
      trainingProviderProfile: current_user.training_provider_profile&.as_json
    }
  end
end
