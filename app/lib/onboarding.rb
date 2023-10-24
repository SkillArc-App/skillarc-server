class Onboarding
  attr_reader :onboarding_session

  def initialize(onboarding_session:)
    @onboarding_session = onboarding_session
  end

  def update(responses:)
    if (name_response = responses.dig("name", "response"))
      user.update!(
        first_name: name_response["firstName"],
        last_name: name_response["lastName"],
        phone_number: name_response["phoneNumber"]
      )

      Resque.enqueue(
        CreateEventJob,
        aggregate_id: user.id,
        event_type: Event::EventTypes::USER_UPDATED,
        data: {
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          phone_number: user.phone_number,
          date_of_birth: Date.strptime(name_response["dateOfBirth"], "%m/%d/%Y"),
        },
        metadata: {},
        occurred_at: user.updated_at
      )

      unless user.profile
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
        OtherExperience.find_or_initialize_by(
          profile_id: user.profile.id,
          **d
        ) do |oe|
          oe.id = SecureRandom.uuid
          oe.save!

          Resque.enqueue(
            CreateEventJob,
            aggregate_id: user.id,
            event_type: "experience_created",
            data: {
              id: oe.id,
              organization_name: oe.organization_name,
              position: oe.position,
              start_date: oe.start_date,
              end_date: oe.end_date,
              description: oe.description,
              is_current: oe.is_current,
              profile_id: oe.profile_id
            },
            metadata: {},
            occurred_at: oe.created_at
          )
        end
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
        EducationExperience.find_or_initialize_by(
          **d
        ) do |ee|
          ee.id = SecureRandom.uuid
          ee.save!

          Resque.enqueue(
            CreateEventJob,
            aggregate_id: user.id,
            event_type: "education_experience_created",
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

    if (tp_response = responses.dig("trainingProvider", "response"))
      tp_response.each do |tr|
        SeekerTrainingProvider.find_or_initialize_by(
          user_id: user.id,
          training_provider_id: tr
        ) do |stp|
          stp.id = SecureRandom.uuid
          stp.save!

          Resque.enqueue(
            CreateEventJob,
            aggregate_id: user.id,
            event_type: "seeker_training_provider_created",
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

        Resque.enqueue(
          CreateEventJob,
          aggregate_id: user.id,
          event_type: "personal_experience_created",
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

    onboarding_session.update!(responses:)

    return unless onboarding_complete?(responses.dig("reliability", "response"), responses) && !onboarding_session.completed_at

    completed_at = Time.now

    onboarding_session.update!(completed_at:)

    Resque.enqueue(
      CreateEventJob,
      aggregate_id: user.id,
      event_type: "onboarding_completed",
      data: {
        responses:
      },
      metadata: {},
      occurred_at: completed_at
    )
  end

  private

  def onboarding_complete?(reliability, responses)
    return false unless reliability
    return false unless (responses.dig("opportunityInterests", "response")&.length || 0).positive?

    reliability.all? do |r|
      if r == "I've had or currently have a job" && (responses.dig("experience", "response")&.length || 0).positive?
        true
      elsif r == 'I have a High School Diploma / GED' && responses.dig("education", "response")&.length&.positive?
        true
      elsif r == "I've attended a Training Program" && (responses.dig("trainingProvider", "response")&.length || 0).positive?
        true
      elsif r == "I have other experience I'd like to share" && (responses.dig("other", "response")&.length || 0).positive?

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
