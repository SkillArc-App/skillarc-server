class SeekerService
  include MessageEmitter

  def initialize(seeker)
    @seeker = seeker
  end

  def get(user_id: nil, seeker_editor: false)
    industry_interests = seeker.onboarding_session&.responses&.dig("opportunityInterests", "response") || []

    if user_id.present? && user_id != seeker.user.id
      message_service.create!(
        schema: Events::SeekerViewed::V1,
        user_id:,
        data: {
          seeker_id: seeker.id
        }
      )
    end

    {
      id: seeker.id,
      about: seeker.about,
      userId: seeker.user.id,
      education_experiences: seeker.education_experiences.map do |ee|
        ee.slice(:id, :organization_name, :title, :graduation_date, :gpa, :activities).symbolize_keys
      end,
      hiring_status: seeker.hiring_status,
      industry_interests:,
      is_profile_editor: seeker_editor,
      other_experiences: seeker.other_experiences.map do |oe|
        oe.slice(:id, :organization_name, :position, :start_date, :end_date, :is_current, :description).symbolize_keys
      end,
      personal_experience: seeker.personal_experiences.map do |pe|
        pe.slice(:id, :activity, :start_date, :end_date, :description).symbolize_keys
      end,
      profile_skills: seeker.profile_skills.map do |ps|
        {
          **ps.slice(:id, :description).symbolize_keys,
          master_skill: ps.master_skill.slice(:id, :skill, :type).symbolize_keys
        }
      end,
      reference: seeker.references.map do |reference|
        {
          reference_text: reference.reference_text,
          training_provider: reference.training_provider.slice(:id, :name).symbolize_keys,
          author_user: reference.user.slice(:id, :email, :first_name, :last_name, :phone_number, :zip_code).symbolize_keys
        }
      end,
      stories: seeker.stories.map { |s| s.slice(:id, :prompt, :response).symbolize_keys },
      missing_profile_items: ProfileCompleteness.new(seeker).status.missing,
      user: {
        **seeker.user.slice(:id, :email, :first_name, :last_name, :phone_number, :zip_code).symbolize_keys,
        seeker_training_providers: seeker.seeker_training_providers.map do |stp|
          {
            program_id: stp&.program&.id,
            training_provider_id: stp.training_provider.id
          }
        end
      }
    }
  end

  private

  attr_reader :profile, :seeker
end
