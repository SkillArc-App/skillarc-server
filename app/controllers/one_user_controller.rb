class OneUserController < ApplicationController
  include Secured
  include Cereal

  before_action :authorize

  def index
    user_ret = deep_transform_keys(current_user.slice(:id, :name, :email, :first_name, :last_name, :zip_code, :phone_number)) { |key| to_camel_case(key) }
    os_ret = (current_user.onboarding_session || {}).slice(:id, :started_at, :completed_at, :responses)

    ActiveRecord::Associations::Preloader.new(
      records: [current_user],
      associations: {
        profile: {
          profile_skills: [:master_skill]
        }
      }
    ).call

    profile = current_user.profile&.slice(
      :id,
      :image,
      :status,
      :bio
    ) || {}

    fast_track_tasks = FastTrackTasks.new(current_user)

    notifications = Notification.where(user: current_user).order(created_at: :desc).limit(10).map do |n|
      {
        notificationTitle: n.title,
        notificationBody: n.body,
        read: n.read?,
        url: n.url
      }
    end

    roles = current_user.user_roles.map do |ur|
      {
        **ur.as_json,
        role: ur.role.as_json
      }
    end || []

    render json: {
      **user_ret,
      onboardingSession: os_ret,
      userRoles: roles,
      fastTrackTasks: {
        profile: fast_track_tasks.profile,
        career: fast_track_tasks.career
      },
      notifications:,
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
        personalExperience: current_user.profile&.personal_experiences || [],
        missingProfileItems: ProfileCompleteness.new(current_user.profile).status.missing
      },
      recruiter: current_user.recruiter&.as_json,
      trainingProviderProfile: current_user.training_provider_profile&.as_json
    }
  end

  def update
    current_user.update!(params.require(:one_user).permit(:first_name, :last_name, :phone_number, :zip_code))

    render json: current_user
  end
end
