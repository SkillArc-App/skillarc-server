class OnboardingSessionsController < ApplicationController
  include Secured
  include Cereal

  before_action :authorize
  skip_before_action :verify_authenticity_token

  def index
    os = OnboardingSession.where(user_id: current_user.id).first

    render json: deep_transform_keys(os.as_json) { |key| to_camel_case(key) }
  end

  def create
    onboarding_session = OnboardingSession.find_or_create_by!(user_id: current_user.id) do |os|
      os.id = SecureRandom.uuid
      os.started_at = Time.now
    end

    render json: deep_transform_keys(onboarding_session.as_json) { |key| to_camel_case(key) }
  end

  def update
    # find onboarding session by id
    os = OnboardingSession.find(params[:id])

    filtered = params.require("onboarding_session").permit(
      responses: {
        education: {
          response: [
            :org,
            :title,
            :gradYear,
            :gpa,
            :activities
          ]
        },
        experience: {
          response: [
            :company,
            :position,
            :startDate,
            :current,
            :endDate,
            :description
          ]
        },
        name: {
          response: [
            :firstName,
            :lastName,
            :phoneNumber,
            :dateOfBirth
          ]
        },
        opportunityInterests: {
          response: []
        },
        other: {
          response: [
            :activity,
            :startDate,
            :endDate,
            :learning
          ]
        },
        reliability: {
          response: []
        },
        trainingProvider: {
          response: []
        }
      }
    ).to_h.symbolize_keys

    responses = filtered[:responses]

    if (name_response = responses.dig("name", "response"))
      current_user.update!(
        first_name: name_response["firstName"],
        last_name: name_response["lastName"]
      )

      if (!current_user.profile)
        Profile.create!(
          id: SecureRandom.uuid,
          user_id: current_user.id
        )
      end
    end

    if (work_response = responses.dig("experience", "response"))
      data = work_response.map do |wr|
        {
          organization_name: wr["company"],
          position: wr["position"],
          start_date: wr["startDate"],
          end_date: wr["endDate"],
          description: wr["description"],
          is_current: wr["current"]
        }
      end

      data.each do |d|
        oe = OtherExperience.find_or_initialize_by(
          profile_id: current_user.profile.id,
          **d
        )
        oe.id = SecureRandom.uuid
        oe.save!
      end
    end

    if (tp_response = responses.dig("trainingProvider", "response"))
      tp_response.each do |tr|
        stp = SeekerTrainingProvider.find_or_initialize_by(
          user_id: current_user.id,
          training_provider_id: tr
        )

        stp.id = SecureRandom.uuid
        stp.save!
      end
    end

    if (education_response = responses.dig("education", "response"))
      data = education_response.map do |er|
        {
          organization_name: er["org"],
          title: er["title"],
          activities: er["activities"],
          graduation_date: er["gradYear"],
          gpa: er["gpa"],
          profile_id: current_user.profile.id
        }
      end

      data.each do |d|
        ee = EducationExperience.find_or_initialize_by(
          **d
        )
        ee.id = SecureRandom.uuid
        ee.save!
      end
    end

    if (other_response = responses.dig("other", "response"))
      data = other_response.map do |oth_r|
        {
          profile_id: current_user.profile.id,
          activity: oth_r["activity"],
          description: oth_r["learning"],
          start_date: oth_r["startDate"],
          end_date: oth_r["endDate"]
        }
      end

      data.each do |d|
        pe = PersonalExperience.find_or_initialize_by(
          **d
        )
        pe.id = SecureRandom.uuid
        pe.save!
      end
    end

    if (opportunity_interests_response = responses.dig("opportunityInterests", "response"))
      data = opportunity_interests_response.map do |oi|
        {
          profile_id: current_user.profile.id,
          response: oi
        }
      end

      data.each do |d|
        pi = ProfessionalInterest.find_or_initialize_by(
          **d
        )
        pi.id = SecureRandom.uuid
        pi.save!
      end
    end

    os.update!(filtered)

    if (onboarding_complete?(responses.dig("reliability", "response"), responses))
      os.update!(completed_at: Time.now)
    end

    render json: deep_transform_keys(os.as_json) { |key| to_camel_case(key) }
  end
end

private

def onboarding_complete?(reliability, responses)
  return false unless reliability
  return false unless (responses.dig("opportunityInterests", "response")&.length || 0) > 0

  reliability.all? do |r|
    if (r == "I've had or currently have a job" && ((responses.dig("experience", "response")&.length || 0) > 0))
      return true
    end

    if (r == 'I have a High School Diploma / GED' && ((responses.dig("education", "response")&.length) > 0))
      return true
    end

    if (
      r == "I've attended a Training Program" && ((responses.dig("trainingProvider", "response")&.length || 0) > 0)
    )
      return true
    end

    if (
      r == "I have other experience I'd like to share" && ((responses.dig("other", "response")&.length || 0) > 0)
    )
      return true
    end

    false
  end
end
