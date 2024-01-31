require 'rails_helper'

RSpec.describe Jobs::CareerPathService do
  describe ".create" do
    subject { described_class.create(job, title:, lower_limit:, upper_limit:) }

    let(:job) { create(:job) }
    let(:title) { "title" }
    let(:lower_limit) { "1" }
    let(:upper_limit) { "2" }

    it "creates a career path" do
      expect { subject }.to change { job.career_paths.count }.by(1)

      career_path = job.career_paths.last

      expect(career_path.title).to eq(title)
      expect(career_path.lower_limit).to eq(lower_limit)
      expect(career_path.upper_limit).to eq(upper_limit)
      expect(career_path.order).to eq(0)
    end

    it "publishes an event" do
      expect(Events::CareerPathCreated::Data::V1).to receive(:new).with(
        id: be_a(String),
        job_id: job.id,
        title:,
        lower_limit:,
        upper_limit:,
        order: 0
      ).and_call_original

      expect(EventService).to receive(:create!).with(
        event_schema: Events::CareerPathCreated::V1,
        aggregate_id: job.id,
        data: be_a(Events::CareerPathCreated::Data::V1)
      ).and_call_original

      subject
    end
  end

  describe ".up" do
    subject { described_class.up(career_path) }

    let!(:career_path) { create(:career_path, order:) }
    let!(:upper_career_path) { create(:career_path, job: career_path.job, order: career_path.order - 1) }
    let(:order) { 1 }

    context "career path is already at the top" do
      let(:order) { 0 }

      it "does not update the order of the career path" do
        expect { subject }.not_to(change { career_path.reload.order })
      end

      it "does not update the order of the upper career path" do
        expect { subject }.not_to(change { upper_career_path.reload.order })
      end

      it "does not publish events" do
        expect(EventService).not_to receive(:create!)
      end
    end

    it "updates the order of the lower career path" do
      expect { subject }.to change { upper_career_path.reload.order }.from(0).to(1)
    end

    it "updates the order of the career path" do
      expect { subject }.to change { career_path.reload.order }.from(1).to(0)
    end

    it "publishes events" do
      expect(Events::CareerPathUpdated::Data::V1).to receive(:new).with(
        id: upper_career_path.id,
        order: 1
      ).and_call_original

      expect(EventService).to receive(:create!).with(
        event_schema: Events::CareerPathUpdated::V1,
        aggregate_id: upper_career_path.job_id,
        data: be_a(Events::CareerPathUpdated::Data::V1)
      ).and_call_original

      expect(Events::CareerPathUpdated::Data::V1).to receive(:new).with(
        id: career_path.id,
        order: 0
      ).and_call_original

      expect(EventService).to receive(:create!).with(
        event_schema: Events::CareerPathUpdated::V1,
        aggregate_id: career_path.job_id,
        data: be_a(Events::CareerPathUpdated::Data::V1)
      ).and_call_original

      subject
    end
  end

  describe ".down" do
    subject { described_class.down(career_path) }

    let!(:career_path) { create(:career_path) }

    context "career path is already at the bottom" do
      it "does not update the order of the career path" do
        expect { subject }.not_to(change { career_path.reload.order })
      end

      it "does not publish events" do
        expect(EventService).not_to receive(:create!)
      end
    end

    context "career path is not at the bottom" do
      let!(:lower_career_path) { create(:career_path, job: career_path.job, order: career_path.order + 1) }

      it "updates the order of the lower career path" do
        expect { subject }.to change { lower_career_path.reload.order }.from(1).to(0)
      end

      it "updates the order of the career path" do
        expect { subject }.to change { career_path.reload.order }.from(0).to(1)
      end

      it "publishes events" do
        expect(Events::CareerPathUpdated::Data::V1).to receive(:new).with(
          id: lower_career_path.id,
          order: 0
        ).and_call_original

        expect(EventService).to receive(:create!).with(
          event_schema: Events::CareerPathUpdated::V1,
          aggregate_id: lower_career_path.job_id,
          data: be_a(Events::CareerPathUpdated::Data::V1)
        ).and_call_original

        expect(Events::CareerPathUpdated::Data::V1).to receive(:new).with(
          id: career_path.id,
          order: 1
        ).and_call_original

        expect(EventService).to receive(:create!).with(
          event_schema: Events::CareerPathUpdated::V1,
          aggregate_id: career_path.job_id,
          data: be_a(Events::CareerPathUpdated::Data::V1)
        ).and_call_original

        subject
      end
    end
  end

  describe ".destroy" do
    subject { described_class.destroy(career_path) }

    let!(:career_path) { create(:career_path) }
    let!(:higher_career_path) { create(:career_path, job: career_path.job, order: career_path.order + 1) }

    it "destroys the career path" do
      expect { subject }.to change { CareerPath.count }.by(-1)
    end

    it "updates the order of the higher career path" do
      expect { subject }.to change { higher_career_path.reload.order }.from(1).to(0)
    end

    it "publishes events" do
      expect(Events::CareerPathDestroyed::Data::V1).to receive(:new).with(
        id: career_path.id
      ).and_call_original

      expect(EventService).to receive(:create!).with(
        event_schema: Events::CareerPathDestroyed::V1,
        aggregate_id: career_path.job_id,
        data: be_a(Events::CareerPathDestroyed::Data::V1)
      ).and_call_original

      expect(Events::CareerPathUpdated::Data::V1).to receive(:new).with(
        id: higher_career_path.id,
        job_id: higher_career_path.job_id,
        title: higher_career_path.title,
        lower_limit: higher_career_path.lower_limit,
        upper_limit: higher_career_path.upper_limit,
        order: higher_career_path.order - 1
      ).and_call_original

      expect(EventService).to receive(:create!).with(
        event_schema: Events::CareerPathUpdated::V1,
        aggregate_id: higher_career_path.job_id,
        data: be_a(Events::CareerPathUpdated::Data::V1)
      ).and_call_original

      subject
    end
  end
end
