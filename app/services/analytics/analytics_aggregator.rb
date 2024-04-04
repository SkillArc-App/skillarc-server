module Analytics
  class AnalyticsAggregator < MessageConsumer
    def reset_for_replay
      Analytics::FactApplication.delete_all
      Analytics::FactJobVisibility.delete_all
      Analytics::DimPerson.delete_all
      Analytics::DimJob.delete_all
    end

    on_message Events::LeadAdded::V2 do |message|
      return if message.data.email.present? && DimPerson.find_by(email: message.data.email)
      return if DimPerson.find_by(phone_number: message.data.phone_number)

      DimPerson.create!(
        lead_id: message.data.lead_id,
        lead_created_at: message.occurred_at,
        phone_number: message.data.phone_number,
        email: message.data.email,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        kind: DimPerson::Kind::LEAD
      )
    end

    on_message Events::UserCreated::V1 do |message|
      data = message.data
      person = DimPerson.find_or_initialize_by(email: data.email)

      person.kind = DimPerson::Kind::USER
      person.last_active_at = message.occurred_at
      person.user_created_at = message.occurred_at
      person.first_name = data.first_name if data.first_name.present?
      person.last_name = data.last_name if data.last_name.present?
      person.email = data.email if data.email.present?

      person.save!
    end

    on_message Events::UserUpdated::V1 do |message|
      person = DimPerson.find_by!(user_id: message.aggregate_id)

      person.update!(
        last_active_at: message.occurred_at,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number,
        email: message.data.email
      )
    end

    on_message Events::SeekerCreated::V1 do |message|
      person = DimPerson.find_by!(user_id: message.aggregate_id)

      person.update!(
        last_active_at: message.occurred_at,
        seeker_id: message.data.id,
        kind: DimPerson::Kind::SEEKER
      )
    end

    on_message Events::OnboardingCompleted::V1 do |message|
      person = DimPerson.find_by!(user_id: message.aggregate_id)

      person.update!(
        last_active_at: message.occurred_at,
        onboarding_completed_at: message.occurred_at
      )
    end

    on_message Events::SessionStarted::V1 do |message|
      person = DimPerson.find_by!(user_id: message.aggregate_id)

      person.update!(last_active_at: message.occurred_at)
    end

    on_message Events::RoleAdded::V1 do |message|
      return unless message.data.role == "coach"

      person = DimPerson.find_by!(user_id: message.aggregate_id)

      person.update!(kind: DimPerson::Kind::COACH)
    end

    on_message Events::EmployerInviteAccepted::V1 do |message|
      person = DimPerson.find_by!(email: message.data.invite_email)

      person.update!(kind: DimPerson::Kind::RECRUITER)
    end

    on_message Events::TrainingProviderInviteAccepted::V1 do |message|
      person = DimPerson.find_by!(email: message.data.invite_email)

      person.update!(kind: DimPerson::Kind::TRAINING_PROVIDER)
    end

    on_message Events::JobCreated::V3 do |message|
      dim_job = DimJob.create!(
        job_id: message.aggregate.job_id,
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
      dim_job = Analytics::DimJob.find_by!(job_id: message.aggregate.job_id)

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

    on_message Events::ApplicantStatusUpdated::V5 do |message|
      data = message.data
      fact_application = Analytics::FactApplication.find_by(application_id: data.applicant_id)

      if fact_application.present?
        fact_application.update!(status: data.status)
      else
        dim_person = Analytics::DimPerson.find_by!(seeker_id: data.seeker_id)
        dim_job = Analytics::DimJob.find_by!(job_id: data.job_id)
        application_number = (dim_person.fact_applications.pluck(:application_number).max || 0) + 1

        Analytics::FactApplication.create!(
          dim_job:,
          dim_person:,
          application_number:,
          status: data.status,
          application_opened_at: message.occurred_at,
          application_id: data.applicant_id
        )
      end
    end
  end
end
