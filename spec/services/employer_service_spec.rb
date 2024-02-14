require 'rails_helper'

RSpec.describe EmployerService do
  describe "#create" do
    subject { described_class.new.create(params) }

    let(:params) do
      {
        name: "Blocktrain",
        location: "Columbus, OH",
        bio: "We are a welding company",
        logo_url: "https://www.blocktrain.com/logo.png"
      }
    end

    it "creates an employer" do
      expect { subject }.to change(Employer, :count).by(1)

      expect(Employer.last).to have_attributes(
        name: "Blocktrain",
        location: "Columbus, OH",
        bio: "We are a welding company",
        logo_url: "https://www.blocktrain.com/logo.png"
      )
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::EmployerCreated::V1,
        aggregate_id: be_present,
        data: Events::EmployerCreated::Data::V1.new(
          name: "Blocktrain",
          location: "Columbus, OH",
          bio: "We are a welding company",
          logo_url: "https://www.blocktrain.com/logo.png"
        )
      ).and_call_original

      subject
    end
  end

  describe "#update" do
    subject { described_class.new.update(employer_id: employer.id, params:) }

    let!(:employer) do
      create(
        :employer,
        name: "Blocktrain",
        location: "Columbus, OH",
        bio: "We are a welding company",
        logo_url: "https://www.blocktrain.com/logo.png"
      )
    end

    let(:params) do
      {
        name: "Portiko",
        location: "Columbus, O-H-I-O",
        bio: "We are a really good welding company",
        logo_url: "https://www.blocktrain.com/logo.jpeg"
      }
    end

    it "updates an employer" do
      subject

      expect(employer.reload).to(
        have_attributes(
          name: "Portiko",
          location: "Columbus, O-H-I-O",
          bio: "We are a really good welding company",
          logo_url: "https://www.blocktrain.com/logo.jpeg"
        )
      )
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::EmployerUpdated::V1,
        aggregate_id: employer.id,
        data: Events::EmployerUpdated::Data::V1.new(
          name: "Portiko",
          location: "Columbus, O-H-I-O",
          bio: "We are a really good welding company",
          logo_url: "https://www.blocktrain.com/logo.jpeg"
        ),
        occurred_at: be_present
      ).and_call_original

      subject
    end
  end
end
