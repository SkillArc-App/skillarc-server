class OneUserController < ApplicationController
  include Secured
  include Cereal

  before_action :authorize

  def index
    user_ret = deep_transform_keys(current_user.slice(:id, :email, :first_name, :last_name, :zip_code, :phone_number)) { |key| to_camel_case(key) }
    os_ret = (current_user.onboarding_session || {}).slice(:id, :started_at, :completed_at, :responses)

    ActiveRecord::Associations::Preloader.new(
      records: [current_user],
      associations: {
        seeker: {
          profile_skills: [:master_skill]
        }
      }
    ).call

    seeker = current_user.seeker&.slice(
      :id,
      :image,
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
        profile: fast_track_tasks.seeker,
        career: fast_track_tasks.career
      },
      notifications:,
      profile: {
        **seeker,
        educationExperiences: current_user.seeker&.education_experiences || [],
        profileCertifications: [],
        profileSkills: current_user.seeker&.profile_skills&.map do |ps|
          {
            **ps.as_json,
            masterSkill: ps.master_skill.as_json
          }
        end || [],
        stories: current_user.seeker&.stories || [],
        otherExperiences: current_user.seeker&.other_experiences || [],
        personalExperience: current_user.seeker&.personal_experiences || [],
        missingProfileItems: ProfileCompleteness.new(current_user.seeker).status.missing
      },
      recruiter: current_user.recruiter&.as_json,
      trainingProviderProfile: current_user.training_provider_profile&.as_json
    }
  end
end
