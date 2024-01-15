class Onboarding # rubocop:disable Metrics/ClassLength
  attr_reader :onboarding_session

  def initialize(onboarding_session:)
    @onboarding_session = onboarding_session
  end

  def update(responses:)
    update_name(retrieve_response_for(responses, "name")) if response_for?(responses, "name")
    update_experience(retrieve_response_for(responses, "experience")) if response_for?(responses, "experience")
    update_education(retrieve_response_for(responses, "education")) if response_for?(responses, "education")
    update_training_provider(retrieve_response_for(responses, "trainingProvider")) if response_for?(responses, "trainingProvider")
    update_other(retrieve_response_for(responses, "other")) if response_for?(responses, "other")
    update_interests(retrieve_response_for(responses, "opportunityInterests")) if response_for?(responses, "opportunityInterests")

    onboarding_session.update!(responses:)

    return unless onboarding_complete?(retrieve_response_for(responses, "reliability"), responses) && !onboarding_session.completed_at

    completed_at = Time.zone.now

    onboarding_session.update!(completed_at:)

    CreateEventJob.perform_later(
      aggregate_id: user.id,
      event_type: Event::EventTypes::ONBOARDING_COMPLETED,
      data: {
        responses:
      },
      metadata: {},
      occurred_at: completed_at
    )
  end

  private

  def update_name(name_response)
    unless user.first_name == name_response["firstName"] &&
           user.last_name == name_response["lastName"] &&
           user.phone_number == name_response["phoneNumber"]
      user.update!(
        first_name: name_response["firstName"],
        last_name: name_response["lastName"],
        phone_number: name_response["phoneNumber"]
      )

      CreateEventJob.perform_later(
        aggregate_id: user.id,
        event_type: Event::EventTypes::USER_UPDATED,
        data: {
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          phone_number: user.phone_number,
          date_of_birth: Date.strptime(name_response["dateOfBirth"], "%m/%d/%Y")
        },
        metadata: {},
        occurred_at: user.updated_at
      )
    end

    return if user.profile

    profile = Profile.create!(
      id: SecureRandom.uuid,
      user:
    )

    CreateEventJob.perform_later(
      aggregate_id: user.id,
      event_type: Event::EventTypes::PROFILE_CREATED,
      data: {
        id: profile.id,
        user_id: user.id
      },
      metadata: {},
      occurred_at: profile.created_at
    )
  end

  def update_experience(work_responses)
    work_responses = work_responses.map do |wr|
      {
        organization_name: wr["company"],
        position: wr["position"],
        start_date: wr["startDate"],
        end_date: wr["endDate"],
        description: wr["description"],
        is_current: wr["current"]
      }
    end

    work_responses.each do |d|
      OtherExperience.find_or_initialize_by(
        profile_id: user.profile.id,
        **d
      ) do |other_experience|
        other_experience.id = SecureRandom.uuid
        other_experience.save!

        CreateEventJob.perform_later(
          aggregate_id: user.id,
          event_type: Event::EventTypes::EXPERIENCE_CREATED,
          data: {
            id: other_experience.id,
            organization_name: other_experience.organization_name,
            position: other_experience.position,
            start_date: other_experience.start_date,
            end_date: other_experience.end_date,
            description: other_experience.description,
            is_current: other_experience.is_current,
            profile_id: other_experience.profile_id
          },
          metadata: {},
          occurred_at: other_experience.created_at
        )
      end
    end
  end

  def update_education(education_responses)
    data = education_responses.map do |er|
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
      EducationExperience.find_or_initialize_by(
        **d
      ) do |ee|
        ee.id = SecureRandom.uuid
        ee.save!

        CreateEventJob.perform_later(
          aggregate_id: user.id,
          event_type: Event::EventTypes::EDUCATION_EXPERIENCE_CREATED,
          data: {
            id: ee.id,
            organization_name: ee.organization_name,
            title: ee.title,
            activities: ee.activities,
            graduation_date: ee.graduation_date,
            gpa: ee.gpa,
            profile_id: ee.profile_id
          },
          metadata: {},
          occurred_at: ee.created_at
        )
      end
    end
  end

  def update_training_provider(tp_responses)
    tp_responses.each do |tr|
      SeekerTrainingProvider.find_or_initialize_by(
        user_id: user.id,
        training_provider_id: tr
      ) do |stp|
        stp.id = SecureRandom.uuid
        stp.save!

        CreateEventJob.perform_later(
          aggregate_id: user.id,
          event_type: Event::EventTypes::SEEKER_TRAINING_PROVIDER_CREATED,
          data: {
            id: stp.id,
            user_id: stp.user_id,
            training_provider_id: stp.training_provider_id
          },
          metadata: {},
          occurred_at: stp.created_at
        )
      end
    end
  end

  def update_other(other_responses)
    data = other_responses.map do |oth_r|
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

      CreateEventJob.perform_later(
        aggregate_id: user.id,
        event_type: Event::EventTypes::PERSONAL_EXPERIENCE_CREATED,
        data: {
          id: pe.id,
          activity: pe.activity,
          description: pe.description,
          start_date: pe.start_date,
          end_date: pe.end_date,
          profile_id: pe.profile_id
        },
        metadata: {},
        occurred_at: pe.created_at
      )
    end
  end

  def update_interests(opportunity_interests_response)
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

  def onboarding_complete?(reliability, responses)
    return false unless reliability
    return false unless (responses.dig("opportunityInterests", "response")&.length || 0).positive?

    reliability.all? do |r|
      if r == "I've had or currently have a job" && response_for?(responses, "experience")
        true
      elsif r == 'I have a High School Diploma / GED' && response_for?(responses, "education")
        true
      elsif r == "I've attended a Training Program" && response_for?(responses, "trainingProvider")
        true
      elsif r == "I have other experience I'd like to share" && response_for?(responses, "other")

        true
      else
        false
      end
    end
  end

  def retrieve_response_for(responses, kind)
    responses.dig(kind, "response")
  end

  def response_for?(responses, kind)
    (responses.dig(kind, "response")&.length || 0).positive?
  end

  def user
    @user ||= onboarding_session.user
  end
end
