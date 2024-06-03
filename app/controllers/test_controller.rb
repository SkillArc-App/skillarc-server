load 'spec/builders/user_builder.rb'
load 'spec/builders/seeker_builder.rb'

class TestController < ApplicationController # rubocop:disable Metrics/ClassLength
  include MessageEmitter

  def create_test_user
    with_message_service do
      user = Builders::UserBuilder.new(message_service).build

      render json: user
    end
  end

  def create_coach
    with_message_service do
      user = Builders::UserBuilder.new(message_service).build

      message_service.create!(
        user_id: user.id,
        schema: Events::RoleAdded::V2,
        data: {
          role: Role::Types::COACH
        }
      )

      render json: user
    end
  end

  def create_seeker
    with_message_service do
      seeker = Builders::SeekerBuilder.new(message_service).build

      render json: {
        user: seeker,
        seeker:
      }
    end
  end

  def create_test_recruiter_with_applicant
    with_message_service do
      job = create_job_with_messages(message_service:)

      recruiter_user = Builders::UserBuilder.new(message_service).build
      FactoryBot.create(:recruiter, employer: job.employer, user: recruiter_user)

      message_service.create!(
        schema: Events::EmployerInviteAccepted::V1,
        employer_id: job.employer.id,
        data: {
          employer_invite_id: SecureRandom.uuid,
          invite_email: recruiter_user.email,
          employer_id: job.employer.id,
          employer_name: job.employer.name
        }
      )

      seeker = Builders::SeekerBuilder.new(message_service).build
      status = create_application_with_message(message_service:, job:, seeker:)

      render json: {
        recruiter: recruiter_user,
        job:,
        applicant: seeker,
        applicant_status: { status: }
      }
    end
  end

  def create_test_trainer_with_student
    with_message_service do
      program = FactoryBot.create(:program)

      training_provider = program.training_provider

      trainer_user = Builders::UserBuilder.new(message_service).build
      student_seeker = Builders::SeekerBuilder.new(message_service).build

      FactoryBot.create(:training_provider_profile, training_provider:, user: trainer_user)
      FactoryBot.create(:seeker_training_provider, training_provider:, program:, seeker_id: student_seeker.id)

      render json: {
        trainer: trainer_user,
        student: student_seeker,
        training_provider:,
        program:
      }
    end
  end

  def create_job
    with_message_service do
      job = create_job_with_messages(message_service:)

      render json: {
        job:,
        employer: job.employer
      }
    end
  end

  def create_seeker_lead
    with_message_service do
      message = message_service.create!(
        schema: Events::PersonAdded::V1,
        person_id: SecureRandom.uuid,
        data: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.first_name,
          phone_number: Faker::PhoneNumber.phone_number,
          email: Faker::Internet.email,
          date_of_birth: nil
        }
      )

      render json: message.data
    end
  end

  def create_active_seeker
    with_message_service do
      seeker = Builders::SeekerBuilder.new(message_service).build(phone_number: nil)

      job = create_job_with_messages(message_service:)
      create_application_with_message(message_service:, job:, seeker:)

      render json: seeker
    end
  end

  def assert_no_failed_jobs
    if Resque::Failure.count.zero?
      head :no_content
    else
      failures = Resque::Failure.all

      failure = if failures.is_a?(Hash)
                  failures
                else
                  failures[0]
                end

      render json: { exception: failure["exception"], message: failure["error"], backtrace: failure["backtrace"] }, status: :ok
    end
  end

  def jobs_settled
    if Resque.peek(:default).nil?
      render json: { settled: true }, status: :ok
    else
      render json: { settled: false }, status: :ok
    end
  end

  def clear_failed_jobs
    Resque::Failure.clear
  end

  private

  def create_application_with_message(message_service:, job:, seeker:)
    message_service.create!(
      schema: Events::ApplicantStatusUpdated::V6,
      application_id: SecureRandom.uuid,
      data: {
        applicant_first_name: seeker.first_name,
        applicant_last_name: seeker.last_name,
        applicant_email: seeker.email,
        applicant_phone_number: seeker.phone_number,
        seeker_id: seeker.id,
        user_id: seeker.user_id,
        job_id: job.id,
        employer_name: job.employer.name,
        employment_title: job.employment_title,
        status: ApplicantStatus::StatusTypes::NEW,
        reasons: []
      },
      metadata: {
        user_id: seeker.user_id
      }
    )

    ApplicantStatus::StatusTypes::NEW
  end

  def create_job_with_messages(message_service:)
    employer_id = SecureRandom.uuid
    job_id = SecureRandom.uuid

    employer = FactoryBot.create(:employer, id: employer_id, location: "Columbus Ohio", name: SecureRandom.uuid, bio: "We are a company.")
    job = FactoryBot.build(:job, employer:, id: job_id,
                                 employment_title: SecureRandom.uuid,
                                 benefits_description: "We have benefits.",
                                 location: "Columbus Ohio")

    message_service.create!(
      schema: Events::EmployerCreated::V1,
      employer_id:,
      data: {
        name: employer.name,
        location: employer.location,
        bio: employer.bio,
        logo_url: "www.google.com"
      }
    )

    message_service.create!(
      schema: Events::JobCreated::V3,
      job_id:,
      data: {
        category: job.category,
        employment_title: job.employment_title,
        employer_name: employer.name,
        employer_id:,
        benefits_description: job.benefits_description,
        location: job.location,
        employment_type: job.employment_type,
        hide_job: false
      }
    )

    job
  end
end
