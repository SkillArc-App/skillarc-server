require 'rails_helper'

RSpec.describe JobFreshnessService do
  shared_context "with recruiter" do
    before do
      described_class.handle_event(employer_invite_accepted, now:)
    end
  end

  let(:base_job_events) { [job_created_at_event] }
  let(:employer_invite_accepted) do
    build(
      :events__message,
      :employer_invite_accepted,
      aggregate_id: employer_id,
      occurred_at: now - 1.week
    )
  end

  let(:now) { Time.zone.local(2024, 1, 1) }
  let(:job_created_at_event) do
    build(
      :events__message,
      :job_created,
      aggregate_id: job_id,
      data: Events::JobCreated::Data::V1.new(
        employment_title: "Welder",
        employer_id:,
        benefits_description: "Benefits",
        responsibilities_description: "Responsibilities",
        location: "Columbus, OH",
        employment_type: "FULLTIME",
        hide_job: false,
        schedule: "9-5",
        work_days: "M-F",
        requirements_description: "Requirements",
        industry: [Job::Industries::MANUFACTURING]
      ),
      occurred_at: job_created_at
    )
  end
  let(:job_created_at) { now - 4.weeks }
  let(:job_id) { "0cff79c1-fb70-4e02-9407-1572c25d8717" }
  let(:employer_id) { "dbd969af-df4f-4ec0-9c23-8549235354c4" }

  describe ".handle_event" do
    subject { described_class.handle_event(event, with_side_effects:, now:) }

    before do
      JobFreshnessEmployerJob.create!(
        employer_id:,
        name: "Blocktrain"
      )
    end

    let(:event) { job_created_at_event }
    let(:with_side_effects) { false }

    context "when the event is not subscribed" do
      let(:event) { build(:events__message, :user_created) }

      it "does nothing" do
        expect { subject }.not_to(change(JobFreshness, :count))

        expect(subject).to eq(true)
      end
    end

    it "returns a hash of FreshnessContexts" do
      expect(subject).to eq(true)
    end

    context "when with side effects is false" do
      it "does not update the database" do
        expect { subject }.not_to(change(JobFreshness, :count))
      end
    end

    context "when with side effects is true" do
      let(:with_side_effects) { true }

      it "creates a JobFreshness" do
        described_class.handle_event(
          build(
            :events__message,
            :employer_created,
            aggregate_id: employer_id,
            data: Events::Common::UntypedHashWrapper.build(
              name: "Blocktrain"
            )
          )
        )

        expect { subject }.to change(JobFreshness, :count).by(1)

        expect(JobFreshness.last_created).to have_attributes(
          job_id:,
          status: "stale",
          employer_name: "Blocktrain",
          employment_title: "Welder"
        )

        expect do
          described_class.handle_event(build(:events__message, :day_elapsed, data: Events::Common::Nothing), now:, with_side_effects: true)
        end.not_to(change(JobFreshness, :count))
      end
    end
  end

  describe "#get" do
    subject { described_class.new(job_id, now:).get }

    before do
      JobFreshnessEmployerJob.create!(
        employer_id:,
        name: "Blocktrain"
      )
      job_events.each do |event|
        described_class.handle_event(event, now:)
      end
    end

    let(:job_events) { base_job_events }

    context "when an employer has a recruiter" do
      context "after the other events" do
        it "returns 'fresh'" do
          described_class.handle_event(job_created_at_event)

          described_class.handle_event(employer_invite_accepted)

          expect(subject).to have_attributes(
            applicants: {},
            employer_name: "Blocktrain",
            employment_title: "Welder",
            job_id:,
            hidden: false,
            recruiter_exists: true,
            status: "fresh"
          )
        end
      end

      context "from the beginning" do
        include_context "with recruiter"

        it "returns 'fresh'" do
          expect(subject).to have_attributes(
            applicants: {},
            employer_name: "Blocktrain",
            employment_title: "Welder",
            job_id:,
            hidden: false,
            recruiter_exists: true,
            status: "fresh"
          )
        end

        context "when the job is hidden" do
          let(:job_events) { base_job_events + [job_hidden_event] }
          let(:job_hidden_event) do
            build(
              :events__message,
              :job_updated,
              aggregate_id: job_id,
              data: Events::Common::UntypedHashWrapper.build(
                employer_id:,
                hide_job: true,
                employment_title: "Welder",
                benefits_description: "Benefits",
                responsibilities_description: "Responsibilities",
                location: "Columbus, OH",
                employment_type: "FULLTIME",
                schedule: "9-5",
                work_days: "M-F",
                requirements_description: "Requirements",
                industry: "manufacturing"
              ),
              occurred_at: job_created_at + 1.day
            )
          end

          it "returns 'stale'" do
            expect(subject).to have_attributes(
              applicants: {},
              job_id:,
              employer_name: "Blocktrain",
              hidden: true,
              recruiter_exists: true,
              status: "stale"
            )
          end
        end

        context "when there are applicants with 'new' status" do
          let(:job_events) { base_job_events + [applicant_created_at_event] }
          let(:applicant_created_at_event) do
            build(
              :events__message,
              :applicant_status_updated,
              aggregate_id: job_id,
              data: Events::ApplicantStatusUpdated::Data::V1.new(
                applicant_id: SecureRandom.uuid,
                job_id:,
                profile_id: SecureRandom.uuid,
                seeker_id: SecureRandom.uuid,
                user_id: SecureRandom.uuid,
                employment_title: "Welder",
                employer_name: "Employer",
                status: "new"
              ),
              occurred_at: applicant_created_at
            )
          end

          context "when the applicant was created less than 1 week ago" do
            let(:applicant_created_at) { now - 1.day }

            it "returns 'fresh'" do
              expect(subject).to have_attributes(
                job_id:,
                status: "fresh",
                applicants: {
                  applicant_created_at_event.data.applicant_id => {
                    last_updated_at: applicant_created_at,
                    status: "new"
                  }.stringify_keys
                },
                employer_name: "Blocktrain",
                employment_title: "Welder",
                hidden: false,
                recruiter_exists: true
              )
            end
          end

          context "when the applicant was created more than 1 week ago" do
            let(:applicant_created_at) { now - 2.weeks }

            context "when the applicant status was updated" do
              let(:job_events) { [] }
              let(:applicant_status_updated_event) do
                build(
                  :events__message,
                  :applicant_status_updated,
                  aggregate_id: job_id,
                  data: Events::ApplicantStatusUpdated::Data::V1.new(
                    applicant_id: applicant_created_at_event.data.applicant_id,
                    job_id:,
                    profile_id: SecureRandom.uuid,
                    user_id: SecureRandom.uuid,
                    employment_title: "Welder",
                    status: "pending intro",
                    seeker_id: SecureRandom.uuid,
                    employer_name: "Employer"
                  ),
                  occurred_at: applicant_status_updated_at
                )
              end
              let(:applicant_status_updated_at) { now - 1.week - 1.day }

              it "returns 'fresh'" do
                described_class.handle_event(job_created_at_event)
                described_class.handle_event(applicant_created_at_event)
                described_class.handle_event(applicant_status_updated_event)

                expect(described_class.new(job_id, now:).get).to have_attributes(
                  job_id:,
                  status: "fresh",
                  applicants: {
                    applicant_created_at_event.data.applicant_id => {
                      last_updated_at: applicant_status_updated_at,
                      status: "pending intro"
                    }.stringify_keys
                  },
                  employer_name: "Blocktrain",
                  employment_title: "Welder",
                  hidden: false,
                  recruiter_exists: true
                )
              end
            end

            it "returns 'stale'" do
              described_class.handle_event(build(:events__message, :day_elapsed, occurred_at: now, data: Events::Common::Nothing)) # Have to wait for the day to elapse

              expect(subject).to have_attributes(
                job_id:,
                status: "stale",
                applicants: {
                  applicant_created_at_event.data.applicant_id => {
                    last_updated_at: applicant_created_at,
                    status: "new"
                  }.stringify_keys
                },
                employer_name: "Blocktrain",
                employment_title: "Welder",
                hidden: false,
                recruiter_exists: true
              )
            end
          end
        end
      end
    end

    context "when the employer has no recruiters" do
      let(:base_job_events) { [job_created_at_event] }

      it "returns 'stale'" do
        expect(subject).to have_attributes(
          job_id:,
          status: "stale",
          applicants: {},
          employer_name: "Blocktrain",
          employment_title: "Welder",
          hidden: false,
          recruiter_exists: false
        )
      end
    end
  end
end
