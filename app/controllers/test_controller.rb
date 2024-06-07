load 'spec/builders/user_builder.rb'
load 'spec/builders/person_builder.rb'

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
      person = Builders::PersonBuilder.new(message_service).build

      message_service.create!(
        user_id: person.user_id,
        schema: Events::RoleAdded::V2,
        data: {
          role: Role::Types::COACH
        }
      )

      render json: person
    end
  end

  def create_seeker
    with_message_service do
      person = Builders::PersonBuilder.new(message_service).build

      render json: {
        user: person,
        person:
      }
    end
  end

  def create_test_recruiter_with_applicant
    with_message_service do
      job = create_job_with_messages(message_service:)

      recruiter_user = Builders::UserBuilder.new(message_service).build
      invite_id = SecureRandom.uuid

      message_service.create!(
        schema: Events::EmployerInviteCreated::V1,
        invite_id:,
        data: {
          invite_email: recruiter_user.email,
          first_name: recruiter_user.first_name,
          last_name: recruiter_user.last_name,
          employer_id: job.employer.id,
          employer_name: job.employer.name
        }
      )

      message_service.create!(
        schema: Events::EmployerInviteAccepted::V2,
        invite_id:,
        data: {
          user_id: recruiter_user.id,
          invite_email: recruiter_user.email,
          employer_id: job.employer.id,
          employer_name: job.employer.name
        }
      )

      person = Builders::PersonBuilder.new(message_service).build
      status = create_application_with_message(message_service:, job:, person:)

      render json: {
        recruiter: recruiter_user,
        job:,
        applicant: person,
        applicant_status: { status: }
      }
    end
  end

  def create_test_trainer_with_student
    with_message_service do
      program = FactoryBot.create(:program)

      training_provider = program.training_provider

      trainer_user = Builders::UserBuilder.new(message_service).build
      student_person = Builders::PersonBuilder.new(message_service).build

      FactoryBot.create(:training_provider_profile, training_provider:, user: trainer_user)
      FactoryBot.create(:seeker_training_provider, training_provider:, program:, seeker_id: student_person.id)

      render json: {
        trainer: trainer_user,
        student: student_person,
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
      person = Builders::PersonBuilder.new(message_service).build(phone_number: nil)

      job = create_job_with_messages(message_service:)
      create_application_with_message(message_service:, job:, person:)

      render json: {
        person:,
        job:,
        employer: job.employer
      }
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

  def create_application_with_message(message_service:, job:, person:)
    message_service.create!(
      schema: Events::ApplicantStatusUpdated::V6,
      application_id: SecureRandom.uuid,
      data: {
        applicant_first_name: person.first_name,
        applicant_last_name: person.last_name,
        applicant_email: person.email,
        applicant_phone_number: person.phone_number,
        seeker_id: person.id,
        user_id: person.user_id,
        job_id: job.id,
        employer_name: job.employer.name,
        employment_title: job.employment_title,
        status: ApplicantStatus::StatusTypes::NEW,
        reasons: []
      },
      metadata: {
        user_id: person.user_id
      }
    )

    ApplicantStatus::StatusTypes::NEW
  end

  def create_job_with_messages(message_service:)
    employer_id = SecureRandom.uuid
    job_id = SecureRandom.uuid

    employer = FactoryBot.build(:employer, id: employer_id, location: "Columbus Ohio", name: SecureRandom.uuid, bio: "We are a company.")
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
