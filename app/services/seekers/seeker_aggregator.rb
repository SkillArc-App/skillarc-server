module Seekers
  class SeekerAggregator < MessageConsumer
    def reset_for_replay
      OtherExperience.delete_all
      EducationExperience.delete_all
      PersonalExperience.delete_all
      SeekerTrainingProvider.delete_all
      ApplicantStatus.delete_all
      Applicant.delete_all
      ProfileSkill.delete_all
      Story.delete_all
      OnboardingSession.delete_all
    end

    on_message Events::BasicInfoAdded::V1, :sync do |message|
      seeker = Seeker.find(message.aggregate.id)
      user = seeker.user

      user.update!(
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number
      )
    end

    # Job experience
    on_message Events::ExperienceAdded::V1, :sync do |message|
      other_expereince = OtherExperience.find_or_initialize_by(id: message.data.id)

      other_expereince.update!(
        seeker_id: message.aggregate.id,
        organization_name: message.data.organization_name,
        position: message.data.position,
        start_date: message.data.start_date,
        end_date: message.data.end_date,
        description: message.data.description,
        is_current: message.data.is_current
      )
    end

    on_message Events::ExperienceRemoved::V1, :sync do |message|
      OtherExperience.find(message.data.id).destroy!
    end

    # Stories
    on_message Events::StoryCreated::V1, :sync do |message|
      Story.create!(
        id: message.data.id,
        prompt: message.data.prompt,
        seeker_id: message.aggregate.id,
        response: message.data.response
      )
    end

    on_message Events::StoryUpdated::V1, :sync do |message|
      story = Story.find(message.data.id)

      story.update!(
        prompt: message.data.prompt,
        response: message.data.response
      )
    end

    on_message Events::StoryDestroyed::V1, :sync do |message|
      Story.find(message.data.id).destroy!
    end

    on_message Events::ApplicantStatusUpdated::V6, :sync do |message|
      application = Applicant.find_or_initialize_by(
        id: message.aggregate.id
      )

      application.update!(
        job_id: message.data.job_id,
        seeker_id: message.data.seeker_id
      )

      application.applicant_statuses.create!(
        id: SecureRandom.uuid,
        status: message.data.status
      )
    end

    on_message Events::ElevatorPitchCreated::V1, :sync do |message|
      applicant = Applicant.find_by!(
        job_id: message.data.job_id,
        seeker_id: message.aggregate_id
      )

      applicant.update!(
        elevator_pitch: message.data.pitch
      )
    end

    # Ed experience
    on_message Events::EducationExperienceAdded::V1, :sync do |message|
      education_experience = EducationExperience.find_or_initialize_by(id: message.data.id)

      education_experience.update!(
        seeker_id: message.aggregate.id,
        id: message.data.id,
        organization_name: message.data.organization_name,
        title: message.data.title,
        activities: message.data.activities,
        graduation_date: message.data.graduation_date,
        gpa: message.data.gpa
      )
    end

    on_message Events::EducationExperienceDeleted::V1, :sync do |message|
      EducationExperience.find(message.data.id).destroy!
    end

    # Personal experience
    on_message Events::PersonalExperienceAdded::V1, :sync do |message|
      personal_experience = PersonalExperience.find_or_initialize_by(id: message.data.id)

      personal_experience.update!(
        seeker_id: message.aggregate.id,
        activity: message.data.activity,
        description: message.data.description,
        start_date: message.data.start_date,
        end_date: message.data.end_date
      )
    end

    on_message Events::PersonalExperienceRemoved::V1, :sync do |message|
      PersonalExperience.find(message.data.id).destroy!
    end

    on_message Events::SeekerSkillCreated::V1, :sync do |message|
      ProfileSkill.create!(
        id: SecureRandom.uuid,
        seeker_id: message.aggregate.id,
        description: message.data.description,
        master_skill_id: message.data.skill_id
      )
    end

    on_message Events::SeekerSkillUpdated::V1, :sync do |message|
      skill = ProfileSkill.find_by!(seeker_id: message.aggregate.id, master_skill_id: message.data.skill_id)

      skill.update!(description: message.data.description)
    end

    on_message Events::SeekerSkillDestroyed::V1, :sync do |message|
      ProfileSkill.find_by!(seeker_id: message.aggregate.id, master_skill_id: message.data.skill_id).destroy!
    end

    on_message Events::SeekerTrainingProviderCreated::V4, :sync do |message|
      seeker_training_provider_created = SeekerTrainingProvider.find_or_initialize_by(id: message.data.id)

      seeker_training_provider_created.update!(
        program_id: message.data.program_id,
        status: message.data.status,
        seeker_id: message.aggregate.id,
        training_provider_id: message.data.training_provider_id
      )
    end

    on_message Events::OnboardingStarted::V1, :sync do |message|
      OnboardingSession.create!(
        id: SecureRandom.uuid,
        seeker_id: message.aggregate.id,
        started_at: message.occurred_at
      )
    end

    on_message Events::OnboardingCompleted::V2, :sync do |message|
      onboarding_session = OnboardingSession.find_by(seeker_id: message.aggregate.id)

      if onboarding_session.present?
        onboarding_session.update!(
          completed_at: message.occurred_at
        )
      else
        OnboardingSession.create!(
          id: SecureRandom.uuid,
          seeker_id: message.aggregate.id,
          started_at: message.occurred_at,
          completed_at: message.occurred_at
        )
      end
    end
  end
end
