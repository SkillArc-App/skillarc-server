class Onboarding
  attr_reader :onboarding_session

  def initialize(onboarding_session:)
    @onboarding_session = onboarding_session
  end

  def update(responses:)
    if (name_response = responses.dig("name", "response"))
      user.update!(
        first_name: name_response["firstName"],
        last_name: name_response["lastName"]
      )

      if (!user.profile)
        Profile.create!(
          id: SecureRandom.uuid,
          user_id: user.id
        )
        user.reload
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
          profile_id: user.profile.id,
          **d
        )
        oe.id = SecureRandom.uuid
        oe.save!
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
          profile_id: user.profile.id
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

    if (tp_response = responses.dig("trainingProvider", "response"))
      tp_response.each do |tr|
        stp = SeekerTrainingProvider.find_or_initialize_by(
          user_id: user.id,
          training_provider_id: tr
        )

        stp.id = SecureRandom.uuid
        stp.save!
      end
    end

    if (other_response = responses.dig("other", "response"))
      data = other_response.map do |oth_r|
        {
          profile_id: user.profile.id,
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
          profile_id: user.profile.id,
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

    onboarding_session.update!(responses: responses)

    if (onboarding_complete?(responses.dig("reliability", "response"), responses))
      completed_at = Time.now

      onboarding_session.update!(completed_at: completed_at)

      Resque.enqueue(
        CreateEventJob,
        aggregate_id: user.id,
        event_type: "onboarding_completed",
        data: {
          responses: responses
        },
        metadata: {},
        occurred_at: completed_at
      )
    end
  end

  private

  def onboarding_complete?(reliability, responses)
    return false unless reliability
    return false unless (responses.dig("opportunityInterests", "response")&.length || 0) > 0
  
    reliability.all? do |r|
      if (r == "I've had or currently have a job" && ((responses.dig("experience", "response")&.length || 0) > 0))
        true
      elsif (r == 'I have a High School Diploma / GED' && ((responses.dig("education", "response")&.length) > 0))
        true
      elsif (
        r == "I've attended a Training Program" && ((responses.dig("trainingProvider", "response")&.length || 0) > 0)
      )
        true
      elsif (
        r == "I have other experience I'd like to share" && ((responses.dig("other", "response")&.length || 0) > 0)
      )
        true
      else
        false
      end
    end
  end

  def user
    @user ||= onboarding_session.user
  end
end