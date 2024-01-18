require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Onboarding do
  subject { described_class.new(onboarding_session:) }

  let!(:onboarding_session) do
    user.onboarding_session
  end
  let(:user) { create(:user) }
  let(:training_provider) { create(:training_provider) }

  it "initalizes with an onboarding session" do
    expect(subject.onboarding_session).not_to be_nil
  end

  describe "#update" do
    subject { described_class.new(onboarding_session:).update(responses:) }

    context "when the responses include name" do
      let(:responses) do
        {
          "name" => {
            "response" => {
              "firstName" => "John",
              "lastName" => "Doe",
              "phoneNumber" => "1234567890",
              "dateOfBirth" => "01/01/2000"
            }
          }
        }
      end

      it "updates the user's information" do
        subject

        expect(user.first_name).to eq("John")
        expect(user.last_name).to eq("Doe")
        expect(user.phone_number).to eq("1234567890")
      end

      it "updates the onboarding session responses" do
        subject

        expect(onboarding_session.responses).to eq(
          {
            "name" => {
              "response" => {
                "firstName" => "John",
                "lastName" => "Doe",
                "phoneNumber" => "1234567890",
                "dateOfBirth" => "01/01/2000"
              }
            }
          }
        )
      end

      it "creates a profile" do
        expect { subject }.to change(Profile, :count).by(1)
        expect(Profile.last_created.user).to eq(user)
      end

      it "publishes a profile created event" do
        allow(EventService).to receive(:create!)
        expect(EventService)
          .to receive(:create!)
          .with(
            aggregate_id: user.id,
            event_type: Event::EventTypes::PROFILE_CREATED,
            data: {
              id: be_present,
              user_id: user.id
            },
            occurred_at: be_present
          ).and_call_original

        subject
      end

      it "publishes an event" do
        allow(EventService).to receive(:create!)
        expect(EventService)
          .to receive(:create!)
          .with(
            aggregate_id: user.id,
            event_type: Event::EventTypes::USER_UPDATED,
            data: {
              email: user.email,
              first_name: "John",
              last_name: "Doe",
              phone_number: "1234567890",
              date_of_birth: Date.new(2000, 1, 1)
            },
            occurred_at: be_present
          ).and_call_original

        subject
      end
    end

    context "when the responses include experience" do
      let(:responses) do
        {
          "name" => {
            "response" => {
              "firstName" => "John",
              "lastName" => "Doe",
              "phoneNumber" => "1234567890",
              "dateOfBirth" => "01/01/2000"
            }
          },
          "experience" => {
            "response" => [{
              "company" => "Company",
              "position" => "Position",
              "startDate" => "01/01/2000",
              "current" => true,
              "endDate" => nil,
              "description" => "Description"
            }]
          }
        }
      end

      it "creates an experience" do
        expect { subject }.to change(OtherExperience, :count).by(1)

        expect(OtherExperience.last_created).to have_attributes(
          organization_name: "Company",
          position: "Position",
          start_date: "01/01/2000",
          is_current: true,
          end_date: nil,
          description: "Description"
        )
      end

      it "publishes an event" do
        allow(EventService).to receive(:create!)
        expect(EventService)
          .to receive(:create!)
          .with(
            aggregate_id: user.id,
            event_type: "experience_created",
            data: {
              id: be_present,
              organization_name: "Company",
              position: "Position",
              start_date: "01/01/2000",
              is_current: true,
              end_date: nil,
              description: "Description",
              profile_id: be_present # TODO: Come up with a way to check the profile id as well
            },
            occurred_at: be_present
          ).and_call_original

        subject
      end

      it "updates the onboarding session responses" do
        subject

        expect(onboarding_session.responses).to include(
          {
            "experience" => {
              "response" => [{
                "company" => "Company",
                "position" => "Position",
                "startDate" => "01/01/2000",
                "current" => true,
                "endDate" => nil,
                "description" => "Description"
              }]
            }
          }
        )
      end
    end

    context "when the responses include education" do
      let(:responses) do
        {
          "name" => {
            "response" => {
              "firstName" => "John",
              "lastName" => "Doe",
              "phoneNumber" => "1234567890",
              "dateOfBirth" => "01/01/2000"
            }
          },
          "education" => {
            "response" => [{
              "activities" => "Football",
              "org" => "School",
              "title" => "Title",
              "gradYear" => "2000",
              "gpa" => "4.0"
            }]
          }
        }
      end

      it "creates an education experience" do
        expect { subject }.to change(EducationExperience, :count).by(1)

        expect(EducationExperience.last_created).to have_attributes(
          activities: "Football",
          organization_name: "School",
          title: "Title",
          graduation_date: "2000",
          gpa: "4.0",
          profile: user.profile
        )
      end

      it "publishes an event" do
        allow(EventService).to receive(:create!)
        expect(EventService)
          .to receive(:create!)
          .with(
            aggregate_id: user.id,
            event_type: "education_experience_created",
            data: {
              id: be_present,
              activities: "Football",
              organization_name: "School",
              title: "Title",
              graduation_date: "2000",
              gpa: "4.0",
              profile_id: be_present # TODO: Come up with a way to check the profile id as well
            },
            occurred_at: be_present
          ).and_call_original

        subject
      end

      it "updates the onboarding session responses" do
        subject

        expect(onboarding_session.responses).to include(
          {
            "education" => {
              "response" => [{
                "activities" => "Football",
                "org" => "School",
                "title" => "Title",
                "gradYear" => "2000",
                "gpa" => "4.0"
              }]
            }
          }
        )
      end
    end

    context "when the responses include trainingProvider" do
      let(:responses) do
        {
          "name" => {
            "response" => {
              "firstName" => "John",
              "lastName" => "Doe",
              "phoneNumber" => "1234567890",
              "dateOfBirth" => "01/01/2000"
            }
          },
          "trainingProvider" => {
            "response" => [
              training_provider.id
            ]
          }
        }
      end

      it "creates a seeker training provider" do
        expect { subject }.to change(SeekerTrainingProvider, :count).by(1)

        expect(SeekerTrainingProvider.last_created).to have_attributes(
          user:,
          training_provider:
        )
      end

      it "publishes an event" do
        allow(EventService).to receive(:create!)
        expect(EventService)
          .to receive(:create!)
          .with(
            aggregate_id: user.id,
            event_type: "seeker_training_provider_created",
            data: {
              id: be_present,
              user_id: user.id,
              training_provider_id: training_provider.id
            },
            occurred_at: be_present
          ).and_call_original

        subject
      end

      it "updates the onboarding session responses" do
        subject

        expect(onboarding_session.responses).to include(
          {
            "trainingProvider" => {
              "response" => [
                training_provider.id
              ]
            }
          }
        )
      end
    end

    context "when the responses include opportunityInterests" do
      let(:responses) do
        {
          "name" => {
            "response" => {
              "firstName" => "John",
              "lastName" => "Doe",
              "phoneNumber" => "1234567890",
              "dateOfBirth" => "01/01/2000"
            }
          },
          "opportunityInterests" => {
            "response" => ["construction"]
          }
        }
      end

      it "updates the onboarding session responses" do
        subject

        expect(onboarding_session.responses).to include(
          {
            "opportunityInterests" => {
              "response" => ["construction"]
            }
          }
        )
      end
    end

    context "when the responses include other" do
      let(:responses) do
        {
          "name" => {
            "response" => {
              "firstName" => "John",
              "lastName" => "Doe",
              "phoneNumber" => "1234567890",
              "dateOfBirth" => "01/01/2000"
            }
          },
          "other" => {
            "response" => [{
              "activity" => "Activity",
              "startDate" => "01/01/2000",
              "endDate" => "01/01/2001",
              "learning" => "Learning"
            }]
          }
        }
      end

      it "creates a personal experience" do
        expect { subject }.to change(PersonalExperience, :count).by(1)

        expect(PersonalExperience.last_created).to have_attributes(
          activity: "Activity",
          start_date: "01/01/2000",
          end_date: "01/01/2001",
          description: "Learning",
          profile: user.profile
        )
      end

      it "publishes an event" do
        allow(EventService).to receive(:create!)
        expect(EventService)
          .to receive(:create!)
          .with(
            aggregate_id: user.id,
            event_type: "personal_experience_created",
            data: {
              id: be_present,
              activity: "Activity",
              start_date: "01/01/2000",
              end_date: "01/01/2001",
              description: "Learning",
              profile_id: be_present # TODO: Come up with a way to check the profile id as well
            },
            occurred_at: be_present
          ).and_call_original

        subject
      end

      it "updates the onboarding session responses" do
        subject

        expect(onboarding_session.responses).to include(
          {
            "other" => {
              "response" => [{
                "activity" => "Activity",
                "startDate" => "01/01/2000",
                "endDate" => "01/01/2001",
                "learning" => "Learning"
              }]
            }
          }
        )
      end
    end

    context "when the responses include opportunityInterests" do
      let(:responses) do
        {
          "name" => {
            "response" => {
              "firstName" => "John",
              "lastName" => "Doe",
              "phoneNumber" => "1234567890",
              "dateOfBirth" => "01/01/2000"
            }
          },
          "opportunityInterests" => {
            "response" => ["construction"]
          }
        }
      end

      it "creates a Professsional Interest" do
        expect { subject }.to change(ProfessionalInterest, :count).by(1)

        expect(ProfessionalInterest.last_created).to have_attributes(
          response: "construction",
          profile: user.profile
        )
      end

      it "updates the onboarding session responses" do
        subject

        expect(onboarding_session.responses).to include(
          {
            "opportunityInterests" => {
              "response" => ["construction"]
            }
          }
        )
      end
    end

    context "when the responses include reliability" do
      context "when all responses are given" do
        let(:responses) do
          {
            "name" => {
              "response" => {
                "firstName" => "John",
                "lastName" => "Doe",
                "phoneNumber" => "1234567890",
                "dateOfBirth" => "01/01/2000"
              }
            },
            "experience" => {
              "response" => [{
                "company" => "Company",
                "position" => "Position",
                "startDate" => "01/01/2000",
                "current" => true,
                "endDate" => nil,
                "description" => "Description"
              }]
            },
            "education" => {
              "response" => [{
                "activities" => "Football",
                "org" => "School",
                "title" => "Title",
                "gradYear" => "2000",
                "gpa" => "4.0"
              }]
            },
            "opportunityInterests" => {
              "response" => ["construction"]
            },
            "other" => {
              "response" => [{
                "activity" => "Activity",
                "startDate" => "01/01/2000",
                "endDate" => "01/01/2001",
                "learning" => "Learning"
              }]
            },
            "reliability" => {
              "response" => [
                "I've had or currently have a job",
                'I have a High School Diploma / GED',
                "I've attended a Training Program",
                "I have other experience I'd like to share"
              ]
            },
            "trainingProvider" => {
              "response" => [
                training_provider.id
              ]
            }
          }
        end

        it "marks the onboarding session as complete" do
          subject

          expect(onboarding_session.completed_at).to be_present
        end

        it "enqueues a job to create a onboarding complete event" do
          allow(EventService).to receive(:create!)
          expect(EventService)
            .to receive(:create!)
            .with(
              aggregate_id: user.id,
              event_type: Event::EventTypes::ONBOARDING_COMPLETED,
              data: {
                responses:
              },
              occurred_at: be_present
            ).and_call_original

          subject
        end
      end

      context "when some responses are missing" do
        let(:responses) do
          {
            "name" => {
              "response" => {
                "firstName" => "John",
                "lastName" => "Doe",
                "phoneNumber" => "1234567890",
                "dateOfBirth" => "01/01/2000"
              }
            },
            "experience" => {
              "response" => [{
                "company" => "Company",
                "position" => "Position",
                "startDate" => "01/01/2000",
                "current" => true,
                "endDate" => nil,
                "description" => "Description"
              }]
            },
            "education" => {
              "response" => [{
                "org" => "School",
                "title" => "Title",
                "gradYear" => "2000",
                "gpa" => "4.0"
              }]
            },
            "opportunityInterests" => {
              "response" => ["construction"]
            },
            "reliability" => {
              "response" => [
                "I've had or currently have a job",
                'I have a High School Diploma / GED',
                "I've attended a Training Program",
                "I have other experience I'd like to share"
              ]
            },
            "trainingProvider" => {
              "response" => [
                training_provider.id
              ]
            }
          }
        end

        it "does not mark the onboarding session as complete" do
          subject

          expect(onboarding_session.completed_at).not_to be_present
        end
      end
    end

    context "when there are repetitive responses" do
      subject { described_class.new(onboarding_session:) }

      let(:responses1) do
        {
          "name" => {
            "response" => {
              "firstName" => "John",
              "lastName" => "Doe",
              "phoneNumber" => "1234567890",
              "dateOfBirth" => "01/01/2000"
            }
          }
        }
      end
      let(:responses2) do
        {
          "name" => {
            "response" => {
              "firstName" => "John",
              "lastName" => "Doe",
              "phoneNumber" => "1234567890",
              "dateOfBirth" => "01/01/2000"
            }
          }
        }
      end

      it "does not duplicate job calls" do
        allow(EventService).to receive(:create!)
        expect(EventService)
          .to receive(:create!)
          .with(
            aggregate_id: user.id,
            event_type: Event::EventTypes::USER_UPDATED,
            data: {
              email: user.email,
              first_name: "John",
              last_name: "Doe",
              phone_number: "1234567890",
              date_of_birth: Date.new(2000, 1, 1)
            },
            occurred_at: be_present
          ).and_call_original

        subject.update(responses: responses1)
        subject.update(responses: responses2)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
