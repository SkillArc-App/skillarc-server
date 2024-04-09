require 'rails_helper'

RSpec.describe EducationExperienceService do
  let(:seeker) { create(:seeker) }

  describe "#create" do
    subject { described_class.new(seeker).create(organization_name:, title:, graduation_date:, gpa:, activities:) }

    include_context "event emitter"

    let(:organization_name) { "University of Cincinnati" }
    let(:title) { "Student" }
    let(:graduation_date) { Date.new(2019, 5, 1).to_s }
    let(:gpa) { "3.5" }
    let(:activities) { "Activities" }

    it "creates an education experience" do
      expect { subject }.to change { EducationExperience.count }.by(1)
    end

    it "publishes an event" do
      expect(Events::EducationExperienceCreated::Data::V1)
        .to receive(:new)
        .with(
          id: be_present,
          organization_name: "University of Cincinnati",
          title: "Student",
          graduation_date: Date.new(2019, 5, 1).to_s,
          gpa: "3.5",
          activities: "Activities",
          seeker_id: seeker.id
        ).and_call_original

      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::EducationExperienceCreated::V1,
        user_id: seeker.user.id,
        data: be_a(Events::EducationExperienceCreated::Data::V1),
        occurred_at: be_a(Time)
      )

      subject
    end
  end

  describe "#update" do
    subject { described_class.new(seeker).update(id:, organization_name:, title:, graduation_date:, gpa:, activities:) }

    include_context "event emitter"

    let!(:education_experience) do
      create(
        :education_experience,
        seeker:,
        organization_name: "The Ohio State University",
        title: "party animal",
        graduation_date: "2013-03-01",
        gpa: 2.5,
        activities: "Football Games"
      )
    end
    let(:id) { education_experience.id }
    let(:organization_name) { "University of Cincinnati" }
    let(:title) { "Student" }
    let(:graduation_date) { "2019-05-01" }
    let(:gpa) { "3.5" }
    let(:activities) { "Activities" }

    it "updates the education experience" do
      expect { subject }
        .to change { education_experience.reload.organization_name }.to("University of Cincinnati")
        .and change { education_experience.reload.title }.to("Student")
        .and change { education_experience.reload.graduation_date }.to("2019-05-01")
        .and change { education_experience.reload.gpa }.to("3.5")
        .and change { education_experience.reload.activities }.to("Activities")
    end

    it "publishes an event" do
      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::EducationExperienceUpdated::V1,
        user_id: seeker.user.id,
        data: Events::EducationExperienceUpdated::Data::V1.new(
          id: education_experience.id,
          organization_name: "University of Cincinnati",
          title: "Student",
          graduation_date: "2019-05-01",
          gpa: "3.5",
          activities: "Activities",
          seeker_id: seeker.id
        ),
        occurred_at: be_a(Time)
      )

      subject
    end
  end

  describe "#destroy" do
    subject { described_class.new(seeker).destroy(id:) }

    include_context "event emitter"

    let!(:education_experience) { create(:education_experience, seeker:) }

    let(:id) { education_experience.id }

    it "destroys the education experience" do
      expect { subject }.to change { EducationExperience.count }.by(-1)
    end

    it "publishes an event" do
      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::EducationExperienceDeleted::V1,
        seeker_id: seeker.id,
        data: Events::EducationExperienceDeleted::Data::V1.new(
          id: education_experience.id
        ),
        occurred_at: be_a(Time)
      )

      subject
    end
  end
end
