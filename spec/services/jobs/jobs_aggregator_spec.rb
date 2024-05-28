require 'rails_helper'

RSpec.describe Jobs::JobsAggregator do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new }

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "DesiredSkillCreated" do
      let(:message) do
        build(
          :message,
          schema: Events::DesiredSkillCreated::V1,
          aggregate_id: job.id,
          data: {
            id:,
            job_id: job.id,
            master_skill_id: master_skill.id
          }
        )
      end
      let(:id) { SecureRandom.uuid }
      let(:job) { create(:job) }
      let(:master_skill) { create(:master_skill) }

      it "creates a desired skill" do
        expect { subject }.to change { DesiredSkill.count }.by(1)

        desired_skill = DesiredSkill.last

        expect(desired_skill.id).to eq(id)
        expect(desired_skill.job_id).to eq(job.id)
        expect(desired_skill.master_skill_id).to eq(master_skill.id)
      end
    end

    context "DesiredSkillDestroyed" do
      let(:message) do
        build(
          :message,
          schema: Events::DesiredSkillDestroyed::V1,
          aggregate_id: desired_skill.job_id,
          data: {
            id: desired_skill.id
          }
        )
      end
      let!(:desired_skill) { create(:desired_skill) }

      it "destroys a desired skill" do
        expect { subject }.to change { DesiredSkill.count }.by(-1)
      end
    end

    context "JobCreated" do
      let(:message) do
        build(
          :message,
          schema: Events::JobCreated::V3,
          aggregate_id: id,
          data: {
            category:,
            employer_name:,
            employment_title:,
            employer_id:,
            benefits_description:,
            responsibilities_description:,
            location:,
            employment_type:,
            hide_job:,
            schedule:,
            work_days:,
            requirements_description:,
            industry:
          }
        )
      end
      let(:id) { SecureRandom.uuid }
      let(:category) { Job::Categories::MARKETPLACE }
      let(:employer_name) { "employer" }
      let(:employment_title) { "title" }
      let(:employer_id) { create(:employer).id }
      let(:benefits_description) { "benefits" }
      let(:responsibilities_description) { "responsibilities" }
      let(:location) { "location" }
      let(:employment_type) { Job::EmploymentTypes::FULLTIME }
      let(:hide_job) { false }
      let(:schedule) { "schedule" }
      let(:work_days) { "work_days" }
      let(:requirements_description) { "requirements" }
      let(:industry) { [Job::Industries::MANUFACTURING] }

      it "creates a job" do
        expect { subject }.to change { Job.count }.by(1)

        job = Job.last

        expect(job.id).to eq(id)
        expect(job.employment_title).to eq(employment_title)
        expect(job.employer_id).to eq(employer_id)
        expect(job.benefits_description).to eq(benefits_description)
        expect(job.responsibilities_description).to eq(responsibilities_description)
        expect(job.location).to eq(location)
        expect(job.employment_type).to eq(employment_type)
        expect(job.hide_job).to eq(hide_job)
        expect(job.schedule).to eq(schedule)
        expect(job.work_days).to eq(work_days)
        expect(job.requirements_description).to eq(requirements_description)
        expect(job.industry).to eq(industry)
      end
    end

    context "JobUpdated" do
      let(:message) do
        build(
          :message,
          schema: Events::JobUpdated::V2,
          aggregate_id: job.id,
          data: {
            category:,
            employment_title:,
            benefits_description:,
            responsibilities_description:,
            location:,
            employment_type:,
            hide_job:,
            schedule:,
            work_days:,
            requirements_description:,
            industry:
          }
        )
      end
      let(:job) { create(:job) }
      let(:category) { Job::Categories::MARKETPLACE }
      let(:employment_title) { "title" }
      let(:benefits_description) { "benefits" }
      let(:responsibilities_description) { "responsibilities" }
      let(:location) { "location" }
      let(:employment_type) { Job::EmploymentTypes::FULLTIME }
      let(:hide_job) { false }
      let(:schedule) { "schedule" }
      let(:work_days) { "work_days" }
      let(:requirements_description) { "requirements" }
      let(:industry) { [Job::Industries::MANUFACTURING] }

      it "updates a job" do
        subject

        expect(job.reload.employment_title).to eq(employment_title)
        expect(job.benefits_description).to eq(benefits_description)
        expect(job.responsibilities_description).to eq(responsibilities_description)
        expect(job.location).to eq(location)
        expect(job.employment_type).to eq(employment_type)
        expect(job.hide_job).to eq(hide_job)
        expect(job.schedule).to eq(schedule)
        expect(job.work_days).to eq(work_days)
        expect(job.requirements_description).to eq(requirements_description)
        expect(job.industry).to eq(industry)
      end
    end

    context "JobAttributeCreated" do
      let(:message) do
        build(
          :message,
          schema: Events::JobAttributeCreated::V1,
          aggregate_id: job.id,
          data: {
            id:,
            attribute_name: "name",
            attribute_id:,
            acceptible_set: %w[A B]
          }
        )
      end
      let(:id) { SecureRandom.uuid }
      let(:attribute_id) { SecureRandom.uuid }
      let(:job) { create(:job) }

      it "creates a job attribute" do
        expect { subject }.to change { JobAttribute.count }.by(1)

        job_attribute = JobAttribute.last

        expect(job_attribute.id).to eq(id)
        expect(job_attribute.attribute_id).to eq(attribute_id)
        expect(job_attribute.attribute_name).to eq("name")
        expect(job_attribute.acceptible_set).to eq(%w[A B])
      end
    end

    context "JobAttributeUpdated" do
      let(:message) do
        build(
          :message,
          schema: Events::JobAttributeUpdated::V1,
          aggregate_id: job_attribute.job_id,
          data: {
            id: job_attribute.id,
            acceptible_set: %w[A B]
          }
        )
      end
      let(:job_attribute) { create(:job_attribute, acceptible_set: %w[A]) }

      it "updates a job attribute" do
        subject

        expect(job_attribute.reload.acceptible_set).to eq(%w[A B])
      end
    end

    context "JobAttributeDestroyed" do
      let(:message) do
        build(
          :message,
          schema: Events::JobAttributeDestroyed::V1,
          aggregate_id: job_attribute.job_id,
          data: {
            id: job_attribute.id
          }
        )
      end
      let(:job_attribute) { create(:job_attribute) }

      it "destroys a job attribute" do
        job_attribute

        expect { subject }.to change { JobAttribute.count }.by(-1)
      end
    end
  end
end
