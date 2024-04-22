require 'rails_helper'

RSpec.describe Search::SearchService do # rubocop:disable Metrics/BlockLength
  describe "#search" do # rubocop:disable Metrics/BlockLength
    subject do
      instance.search(
        search_terms:,
        industries:,
        tags:,
        user:,
        utm_source:
      )
    end

    let(:instance) { described_class.new(message_service: MessageService.new) }

    let(:search_terms) { nil }
    let(:industries) { nil }
    let(:tags) { nil }
    let(:user) { nil }
    let(:utm_source) { nil }

    before do
      instance.handle_message(job_created1)
      instance.handle_message(job_created2)
      instance.handle_message(job_created3)
      instance.handle_message(job_updated1)
      instance.handle_message(job_tag_created1_for_job2)
      instance.handle_message(job_tag_created2_for_job2)
      instance.handle_message(job_tag_created1_for_job1)
      instance.handle_message(job_tag_destroyed1_for_job2)
      instance.handle_message(career_paths_created_for_job1)
      instance.handle_message(career_paths_created_for_job2)
      instance.handle_message(career_paths_updated_for_job2)
      instance.handle_message(application1_for_job1_for_seeker1)
      instance.handle_message(application2_for_job2_for_seeker2)
      instance.handle_message(elevator_pitch_created_for_application2)
      instance.handle_message(job_saved_job1_user1)
      instance.handle_message(job_saved_job2_user1)
      instance.handle_message(job_unsaved_job2_user1)
    end

    let(:applicant_id1) { "bbd92d61-8367-46e0-aafe-89369df95eba" }
    let(:applicant_id2) { "b3f5fe09-e227-4d2a-b47a-bba51b33c23b" }
    let(:job_id1) { "516efc70-a246-4692-9b61-5321dcd2291b" }
    let(:job_id2) { "d2104dff-f8eb-4122-acdb-48369b0ecc4e" }
    let(:job_id3) { "f20f2134-fea2-46bd-a280-004e0f41a045" }
    let(:user_id1) { "f24fd7b6-e4ca-441e-b207-f3ad8684a02b" }
    let(:user_id2) { "915816cb-4ea9-4a6e-b48d-5162ce12f786" }
    let(:seeker_id1) { "6c535506-3289-4ffe-9767-a258f760de35" }
    let(:seeker_id2) { "6ec7a915-12cf-46a6-bca9-ca25599e73cd" }

    let(:employer_id1) { employer1.id }
    let(:employer_id2) { employer2.id }

    let(:employer1) { create(:employer) }
    let(:employer2) { create(:employer) }
    let(:tag1) { create(:tag, name: "Tag1") }
    let(:tag2) { create(:tag, name: "Tag2") }

    let(:job_created1) do
      build(
        :message,
        schema: Events::JobCreated::V3,
        aggregate_id: job_id1,
        data: {
          category: Job::Categories::STAFFING,
          employment_title: "Plumber",
          employer_name: "Good Employer",
          employer_id: employer_id1,
          benefits_description: "Great Benifits",
          location: "Columbus, OH",
          employment_type: Job::EmploymentTypes::FULLTIME,
          hide_job: false,
          industry: nil
        }
      )
    end
    let(:job_created2) do
      build(
        :message,
        aggregate_id: job_id2,
        schema: Events::JobCreated::V3,
        data: {
          category: Job::Categories::STAFFING,
          employment_title: "Mechanic",
          employer_name: "Joe's Mechanic's shop",
          employer_id: employer_id2,
          benefits_description: "Great Benifits",
          location: "Columbus, OH",
          employment_type: Job::EmploymentTypes::PARTTIME,
          hide_job: false,
          industry: [Job::Industries::CONSTRUCTION, Job::Industries::MANUFACTURING]
        }
      )
    end
    let(:job_created3) do
      build(
        :message,
        aggregate_id: job_id3,
        schema: Events::JobCreated::V3,
        data: {
          category: Job::Categories::MARKETPLACE,
          employment_title: "Silly Job",
          employer_name: "Good Employer",
          employer_id: employer_id1,
          benefits_description: "Great Benifits",
          location: "Columbus, OH",
          employment_type: Job::EmploymentTypes::PARTTIME,
          hide_job: false,
          industry: [Job::Industries::LOGISTICS]
        }
      )
    end
    let(:job_updated1) do
      build(
        :message,
        aggregate_id: job_id1,
        schema: Events::JobUpdated::V2,
        data: {
          category: Job::Categories::MARKETPLACE,
          employment_title: "Senior Plumber",
          benefits_description: "Great Benifits",
          location: "Columbus, OH",
          employment_type: Job::EmploymentTypes::FULLTIME,
          hide_job: false,
          industry: nil
        }
      )
    end
    let(:job_tag_created1_for_job2) do
      build(
        :message,
        aggregate_id: job_id2,
        schema: Events::JobTagCreated::V1,
        data: {
          job_id: job_id2,
          tag_id: tag1.id
        }
      )
    end
    let(:job_tag_created2_for_job2) do
      build(
        :message,
        aggregate_id: job_id2,
        schema: Events::JobTagCreated::V1,
        data: {
          job_id: job_id2,
          tag_id: tag2.id
        }
      )
    end
    let(:job_tag_created1_for_job1) do
      build(
        :message,
        aggregate_id: job_id1,
        schema: Events::JobTagCreated::V1,
        data: {
          job_id: job_id1,
          tag_id: tag1.id
        }
      )
    end
    let(:job_tag_destroyed1_for_job2) do
      build(
        :message,
        aggregate_id: job_id2,
        schema: Events::JobTagDestroyed::V2,
        data: {
          job_id: job_id1,
          job_tag_id: SecureRandom.uuid,
          tag_id: tag1.id
        }
      )
    end
    let(:career_paths_created_for_job1) do
      build(
        :message,
        aggregate_id: job_id1,
        schema: Events::CareerPathCreated::V1,
        data: {
          id: SecureRandom.uuid,
          job_id: job_id1,
          title: "Entry Level",
          lower_limit: "17000",
          upper_limit: "23000",
          order: 0
        }
      )
    end
    let(:career_paths_created_for_job2) do
      build(
        :message,
        aggregate_id: job_id2,
        schema: Events::CareerPathCreated::V1,
        data: {
          id: SecureRandom.uuid,
          job_id: job_id2,
          title: "Grunt",
          lower_limit: "10",
          upper_limit: "15",
          order: 0
        }
      )
    end
    let(:career_paths_updated_for_job2) do
      build(
        :message,
        aggregate_id: job_id2,
        schema: Events::CareerPathUpdated::V1,
        data: {
          id: SecureRandom.uuid,
          job_id: job_id2,
          title: "Top Grunt",
          lower_limit: "12",
          upper_limit: "17",
          order: 0
        }
      )
    end
    let(:application1_for_job1_for_seeker1) do
      build(
        :message,
        aggregate_id: applicant_id1,
        schema: Events::ApplicantStatusUpdated::V6,
        data: {
          applicant_first_name: "John",
          applicant_last_name: "Chabot",
          applicant_email: "john@skillarc.com",
          seeker_id: seeker_id1,
          user_id: user_id1,
          job_id: job_id1,
          employer_name: "Good Employer",
          employment_title: "Plumber",
          status: ApplicantStatus::StatusTypes::INTERVIEWING
        },
        metadata: {
          user_id: user_id1
        }
      )
    end
    let(:application2_for_job2_for_seeker2) do
      build(
        :message,
        aggregate_id: applicant_id2,
        schema: Events::ApplicantStatusUpdated::V6,
        data: {
          applicant_first_name: "Chris",
          applicant_last_name: "Brauns",
          applicant_email: "chris@skillarc.com",
          seeker_id: seeker_id2,
          user_id: user_id2,
          job_id: job_id2,
          employer_name: "Good Employer",
          employment_title: "Plumber",
          status: ApplicantStatus::StatusTypes::INTERVIEWING
        },
        metadata: {
          user_id: user_id1
        }
      )
    end
    let(:elevator_pitch_created_for_application2) do
      build(
        :message,
        aggregate_id: seeker_id2,
        schema: Events::ElevatorPitchCreated::V1,
        data: {
          job_id: job_id2,
          pitch: "I'm going to be the very best"
        }
      )
    end
    let(:job_saved_job1_user1) do
      build(
        :message,
        aggregate_id: user_id1,
        schema: Events::JobSaved::V1,
        data: {
          job_id: job_id1,
          employment_title: "A Job",
          employer_name: "Employer"
        }
      )
    end
    let(:job_saved_job2_user1) do
      build(
        :message,
        aggregate_id: user_id1,
        schema: Events::JobSaved::V1,
        data: {
          job_id: job_id2,
          employment_title: "A Job",
          employer_name: "Employer"
        }
      )
    end
    let(:job_unsaved_job2_user1) do
      build(
        :message,
        aggregate_id: user_id1,
        schema: Events::JobUnsaved::V1,
        data: {
          job_id: job_id2,
          employment_title: "A Job",
          employer_name: "Employer"
        }
      )
    end

    let(:expected_job1_no_user) do
      {
        id: job_id1,
        category: Job::Categories::MARKETPLACE,
        employment_title: "Senior Plumber",
        industries: nil,
        location: "Columbus, OH",
        starting_pay: {
          employment_type: "salary",
          lower_limit: 17_000,
          upper_limit: 23_000
        },
        tags: ["Tag1"],
        application_status: nil,
        elevator_pitch: nil,
        saved: nil,
        employer: {
          id: employer_id1,
          name: "Good Employer",
          logo_url: employer1.logo_url
        }
      }
    end
    let(:expected_job2_no_user) do
      {
        id: job_id2,
        category: Job::Categories::STAFFING,
        employment_title: "Mechanic",
        industries: [Job::Industries::CONSTRUCTION, Job::Industries::MANUFACTURING],
        location: "Columbus, OH",
        starting_pay: {
          employment_type: "hourly",
          lower_limit: 12,
          upper_limit: 17
        },
        tags: %w[Tag1 Tag2],
        application_status: nil,
        elevator_pitch: nil,
        saved: nil,
        employer: {
          id: employer_id2,
          name: "Joe's Mechanic's shop",
          logo_url: employer2.logo_url
        }
      }
    end
    let(:expected_job3_no_user) do
      {
        id: job_id3,
        category: Job::Categories::MARKETPLACE,
        employment_title: "Silly Job",
        industries: [Job::Industries::LOGISTICS],
        location: "Columbus, OH",
        starting_pay: nil,
        tags: [],
        application_status: nil,
        elevator_pitch: nil,
        saved: nil,
        employer: {
          id: employer_id1,
          name: "Good Employer",
          logo_url: employer1.logo_url
        }
      }
    end

    context "search source" do
      context "when user is nil" do
        it "emits a search event for unauthenticated" do
          expect_any_instance_of(MessageService)
            .to receive(:create!)
            .with(
              schema: Events::JobSearch::V2,
              data: {
                search_terms:,
                industries:,
                tags:
              },
              search_id: 'unauthenticated',
              metadata: {
                source: "unauthenticated",
                utm_source:
              }
            )

          subject
        end
      end

      context "when user doesn't have a seeker" do
        let(:user) { create(:user) }

        it "emits a search event for a non-seeker" do
          expect_any_instance_of(MessageService)
            .to receive(:create!)
            .with(
              schema: Events::JobSearch::V2,
              data: {
                search_terms:,
                industries:,
                tags:
              },
              search_id: user.id,
              metadata: {
                source: "user",
                id: user.id,
                utm_source:
              }
            )

          subject
        end
      end

      context "when user does have a seeker" do
        let(:user) { seeker.user }
        let(:seeker) { create(:seeker) }

        it "emits a search event for a non-seeker" do
          expect_any_instance_of(MessageService)
            .to receive(:create!)
            .with(
              schema: Events::JobSearch::V2,
              data: {
                search_terms:,
                industries:,
                tags:
              },
              search_id: user.id,
              metadata: {
                source: "seeker",
                id: user.id,
                utm_source:
              }
            )

          subject
        end
      end
    end

    context "when no constraints are provided" do
      context "when no user is provided" do
        it "returns all jobs" do
          expect(subject[0]).to eq(expected_job2_no_user)
          expect(subject).to contain_exactly(expected_job2_no_user, expected_job3_no_user, expected_job1_no_user)
        end
      end

      context "when user is provided" do
        let(:user) { create(:user, id: user_id1) }

        it "returns all jobs with saved jobs" do
          expected_result = [
            {
              id: job_id2,
              category: Job::Categories::STAFFING,
              employment_title: "Mechanic",
              industries: [Job::Industries::CONSTRUCTION, Job::Industries::MANUFACTURING],
              location: "Columbus, OH",
              starting_pay: {
                employment_type: "hourly",
                lower_limit: 12,
                upper_limit: 17
              },
              tags: %w[Tag1 Tag2],
              application_status: nil,
              elevator_pitch: nil,
              saved: false,
              employer: {
                id: employer_id2,
                name: "Joe's Mechanic's shop",
                logo_url: employer2.logo_url
              }
            },
            {
              id: job_id3,
              category: Job::Categories::MARKETPLACE,
              employment_title: "Silly Job",
              industries: [Job::Industries::LOGISTICS],
              location: "Columbus, OH",
              starting_pay: nil,
              tags: [],
              application_status: nil,
              elevator_pitch: nil,
              saved: false,
              employer: {
                id: employer_id1,
                name: "Good Employer",
                logo_url: employer1.logo_url
              }
            },
            {
              id: job_id1,
              category: Job::Categories::MARKETPLACE,
              employment_title: "Senior Plumber",
              industries: nil,
              location: "Columbus, OH",
              starting_pay: {
                employment_type: "salary",
                lower_limit: 17_000,
                upper_limit: 23_000
              },
              tags: ["Tag1"],
              application_status: nil,
              elevator_pitch: nil,
              saved: true,
              employer: {
                id: employer_id1,
                name: "Good Employer",
                logo_url: employer1.logo_url
              }
            }
          ]

          expect(subject[0]).to eq(expected_result[0])
          expect(subject).to contain_exactly(*expected_result)
        end
      end

      context "when user with a seeker is provided" do
        let(:user) { create(:user, id: user_id1) }
        let!(:seeker) { create(:seeker, id: seeker_id2, user:) }

        it "returns all jobs with saved jobs" do
          expected_result = [
            {
              id: job_id2,
              category: Job::Categories::STAFFING,
              employment_title: "Mechanic",
              industries: [Job::Industries::CONSTRUCTION, Job::Industries::MANUFACTURING],
              location: "Columbus, OH",
              starting_pay: {
                employment_type: "hourly",
                lower_limit: 12,
                upper_limit: 17
              },
              tags: %w[Tag1 Tag2],
              application_status: "interviewing",
              elevator_pitch: "I'm going to be the very best",
              saved: false,
              employer: {
                id: employer_id2,
                name: "Joe's Mechanic's shop",
                logo_url: employer2.logo_url
              }
            },
            {
              id: job_id3,
              category: Job::Categories::MARKETPLACE,
              employment_title: "Silly Job",
              industries: [Job::Industries::LOGISTICS],
              location: "Columbus, OH",
              starting_pay: nil,
              tags: [],
              application_status: nil,
              elevator_pitch: nil,
              saved: false,
              employer: {
                id: employer_id1,
                name: "Good Employer",
                logo_url: employer1.logo_url
              }
            },
            {
              id: job_id1,
              category: Job::Categories::MARKETPLACE,
              employment_title: "Senior Plumber",
              industries: nil,
              location: "Columbus, OH",
              starting_pay: {
                employment_type: "salary",
                lower_limit: 17_000,
                upper_limit: 23_000
              },
              tags: ["Tag1"],
              application_status: nil,
              elevator_pitch: nil,
              saved: true,
              employer: {
                id: employer_id1,
                name: "Good Employer",
                logo_url: employer1.logo_url
              }
            }
          ]

          expect(subject[0]).to eq(expected_result[0])
          expect(subject).to contain_exactly(*expected_result)
        end
      end
    end

    context "when search terms are provided" do
      context "when the search terms doesn't match anything" do
        let(:search_terms) { "Zoo Person" }

        it "returns all no jobs" do
          expect(subject).to eq([])
        end
      end

      context "when the search terms is less than three characters" do
        let(:search_terms) { "a" }

        it "is ignored and returns all jobs" do
          expect(subject[0]).to eq(expected_job2_no_user)
          expect(subject).to contain_exactly(expected_job2_no_user, expected_job3_no_user, expected_job1_no_user)
        end
      end

      context "when the search terms match a job" do
        let(:search_terms) { "Plumber" }

        it "returns all no jobs" do
          expect(subject).to eq([expected_job1_no_user])
        end
      end

      context "when the search terms case insenstive match a job" do
        let(:search_terms) { "plumber" }

        it "returns all no jobs" do
          expect(subject).to eq([expected_job1_no_user])
        end
      end

      context "when the search terms case insenstive match an employer" do
        let(:search_terms) { "Joe" }

        it "returns all no jobs" do
          expect(subject).to eq([expected_job2_no_user])
        end
      end
    end

    context "when industries are provided" do
      context "when industries don't match anything" do
        let(:industries) { ["Poker"] }

        it "returns all no jobs" do
          expect(subject).to eq([])
        end
      end

      context "When there is overlap with industries" do
        let(:industries) { [Job::Industries::CONSTRUCTION, Job::Industries::LOGISTICS] }

        it "returns all jobs with overlapping industries" do
          expect(subject).to eq([expected_job2_no_user, expected_job3_no_user])
        end
      end
    end

    context "when tags are provided" do
      context "when tags don't match anything" do
        let(:tags) { ["Certified Lame"] }

        it "returns all no jobs" do
          expect(subject).to eq([])
        end
      end

      context "When there is overlap with industries" do
        let(:tags) { %w[Tag3 Tag2] }

        it "all jobs with overlapping tags" do
          expect(subject).to eq([expected_job2_no_user])
        end
      end
    end

    context "when everything is used" do
      let(:search_terms) { "Joe" }
      let(:industries) { [Job::Industries::CONSTRUCTION] }
      let(:tags) { ["Tag2"] }

      it "returns the matching job" do
        expect(subject).to eq([expected_job2_no_user])
      end
    end
  end
end
