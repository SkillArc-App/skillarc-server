module Analytics
  class AnalyticsAggregator < MessageConsumer # rubocop:disable Metrics/ClassLength
    def reset_for_replay
      Analytics::FactApplication.delete_all
      Analytics::FactJobVisibility.delete_all
      Analytics::FactPersonViewed.delete_all
      Analytics::FactCoachAction.delete_all
      Analytics::DimPerson.delete_all
      Analytics::DimJob.delete_all
      Analytics::DimUser.delete_all
    end

    on_message Events::PersonAssociatedToUser::V1 do |message|
      person = DimPerson.find_by!(person_id: message.stream.person_id)
      user = DimUser.find_by!(user_id: message.data.user_id)

      person.dim_user = user
      person.save!
    end

    on_message Events::UserCreated::V1 do |message|
      data = message.data

      DimUser.create!(
        user_id: message.stream.user_id,
        email: data.email,
        kind: DimUser::Kind::USER,
        first_name: data.first_name,
        last_name: data.last_name,
        user_created_at: message.occurred_at
      )
    end

    on_message Events::BasicInfoAdded::V1 do |message|
      person = DimPerson.find_by!(person_id: message.stream.person_id)

      person.update!(
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number,
        email: message.data.email
      )
    end

    on_message Events::PersonAdded::V1 do |message|
      DimPerson.create!(
        person_id: message.stream.person_id,
        email: message.data.email,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        kind: DimPerson::Kind::SEEKER
      )
    end

    on_message Events::OnboardingCompleted::V3 do |message|
      person = DimPerson.find_by!(person_id: message.stream.person_id)

      person.update!(
        onboarding_completed_at: message.occurred_at
      )
    end

    on_message Events::SessionStarted::V1 do |message|
      user = DimUser.find_by!(user_id: message.stream.user_id)

      user.update!(last_active_at: message.occurred_at)
    end

    on_message Events::CoachAdded::V1 do |message|
      user = DimUser.find_by!(user_id: message.stream.user_id)

      user.update!(kind: DimUser::Kind::COACH, coach_id: message.data.coach_id)
    end

    on_message Events::EmployerInviteAccepted::V2 do |message|
      user = DimUser.find_by!(user_id: message.data.user_id)

      user.update!(kind: DimUser::Kind::RECRUITER)
    end

    on_message Events::TrainingProviderInviteAccepted::V2 do |message|
      user = DimUser.find_by!(user_id: message.data.user_id)

      return unless user

      user.update!(kind: DimUser::Kind::TRAINING_PROVIDER)
    end

    on_message Events::JobCreated::V3 do |message|
      dim_job = DimJob.create!(
        job_id: message.stream.job_id,
        category: message.data.category,
        employment_title: message.data.employment_title,
        employment_type: message.data.employment_type,
        job_created_at: message.occurred_at
      )

      unless message.data.hide_job
        Analytics::FactJobVisibility.create!(
          dim_job:,
          visible_starting_at: message.occurred_at
        )
      end
    end

    on_message Events::JobUpdated::V2 do |message|
      dim_job = Analytics::DimJob.find_by!(job_id: message.stream.job_id)

      dim_job.update!(
        category: message.data.category,
        employment_title: message.data.employment_title,
        employment_type: message.data.employment_type
      )

      job_visibility = Analytics::FactJobVisibility.find_by(dim_job:, visible_ending_at: nil)

      return if message.data.hide_job.nil?

      # If we have an existing visible job fact without and end date
      # and we now have an update for hiding the job, we update the end date
      if job_visibility.present? && message.data.hide_job == true # rubocop:disable Style/IfUnlessModifier
        job_visibility.update!(visible_ending_at: message.occurred_at)
      end

      # If we don't ahve an existing visible job fact without and end date
      # and we now have an update where we are showing the job we create
      # a new visibility record
      if job_visibility.blank? && message.data.hide_job == false # rubocop:disable Style/IfUnlessModifier
        Analytics::FactJobVisibility.create!(dim_job:, visible_starting_at: message.occurred_at)
      end
    end

    on_message Events::ApplicantStatusUpdated::V6 do |message|
      data = message.data
      fact_application = Analytics::FactApplication.find_by(application_id: message.stream.id)

      if fact_application.present?
        fact_application.update!(status: data.status, application_updated_at: message.occurred_at)
      else
        dim_person = Analytics::DimPerson.find_by!(person_id: data.seeker_id)
        dim_job = Analytics::DimJob.find_by!(job_id: data.job_id)
        application_number = (dim_person.fact_applications.pluck(:application_number).max || 0) + 1

        Analytics::FactApplication.create!(
          dim_job:,
          dim_person:,
          employment_title: data.employment_title,
          employer_name: data.employer_name,
          application_number:,
          status: data.status,
          application_opened_at: message.occurred_at,
          application_id: message.stream.id,
          application_updated_at: message.occurred_at
        )
      end
    end

    on_message Events::PersonViewed::V1 do |message|
      dim_user_viewer = Analytics::DimUser.find_by!(user_id: message.stream.user_id)
      dim_person_viewed = Analytics::DimPerson.find_by!(person_id: message.data.person_id)

      Analytics::FactPersonViewed.create!(
        dim_user_viewer:,
        dim_person_viewed:,
        viewed_at: message.occurred_at,
        viewing_context: Analytics::FactPersonViewed::Contexts::PUBLIC_PROFILE
      )
    end

    on_message Events::PersonViewedInCoaching::V1 do |message|
      dim_user_viewer = Analytics::DimUser.find_by!(coach_id: message.stream.coach_id)
      dim_person_viewed = DimPerson.find_by(person_id: message.data.person_id)

      Analytics::FactPersonViewed.create!(
        dim_user_viewer:,
        dim_person_viewed:,
        viewed_at: message.occurred_at,
        viewing_context: Analytics::FactPersonViewed::Contexts::COACHES_DASHBOARD
      )
    end

    on_message Events::NoteAdded::V4 do |message|
      note_action(
        person_id: message.stream.person_id,
        originator: message.data.originator,
        action: Analytics::FactCoachAction::Actions::NOTE_ADDED,
        occurred_at: message.occurred_at
      )
    end

    on_message Events::NoteModified::V4 do |message|
      note_action(
        person_id: message.stream.person_id,
        originator: message.data.originator,
        action: Analytics::FactCoachAction::Actions::NOTE_MODIFIED,
        occurred_at: message.occurred_at
      )
    end

    on_message Events::NoteDeleted::V4 do |message|
      note_action(
        person_id: message.stream.person_id,
        originator: message.data.originator,
        action: Analytics::FactCoachAction::Actions::NOTE_DELETED,
        occurred_at: message.occurred_at
      )
    end

    on_message Events::JobRecommended::V3 do |message|
      dim_user_executor = Analytics::DimUser.find_by!(coach_id: message.data.coach_id)
      dim_person_target = Analytics::DimPerson.find_by!(person_id: message.stream.person_id)

      Analytics::FactCoachAction.create!(
        dim_user_executor:,
        dim_person_target:,
        action: Analytics::FactCoachAction::Actions::JOB_RECOMMENDED,
        action_taken_at: message.occurred_at
      )
    end

    on_message Events::PersonCertified::V1 do |message|
      dim_user_executor = Analytics::DimUser.find_by!(coach_id: message.data.coach_id)
      dim_person_target = Analytics::DimPerson.find_by!(person_id: message.stream.person_id)

      Analytics::FactCoachAction.create!(
        dim_user_executor:,
        dim_person_target:,
        action: Analytics::FactCoachAction::Actions::SEEKER_CERTIFIED,
        action_taken_at: message.occurred_at
      )
    end

    private

    def note_action(person_id:, originator:, action:, occurred_at:)
      dim_user_executor = Analytics::DimUser.find_by(email: originator)
      return if dim_user_executor.blank?

      dim_person_target = DimPerson.find_by!(person_id:)
      return if dim_person_target.blank?

      Analytics::FactCoachAction.create!(
        dim_user_executor:,
        dim_person_target:,
        action:,
        action_taken_at: occurred_at
      )
    end
  end
end
