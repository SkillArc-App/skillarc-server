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
      expect { subject }.to change { Employer.count }.by(1)

      expect(Employer.last).to have_attributes(
        name: "Blocktrain",
        location: "Columbus, OH",
        bio: "We are a welding company",
        logo_url: "https://www.blocktrain.com/logo.png"
      )
    end

    it "publishes an event" do
      expect(Resque).to receive(:enqueue).with(
        CreateEventJob,
        event_type: Event::EventTypes::EMPLOYER_CREATED,
        aggregate_id: be_present,
        data: {
          name: "Blocktrain",
          location: "Columbus, OH",
          bio: "We are a welding company",
          logo_url: "https://www.blocktrain.com/logo.png"
        },
        occurred_at: be_present,
        metadata: {}
      )

      subject
    end
  end

  describe "#update" do
    subject { described_class.new.update(employer_id: employer.id, params: params) }
    
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
      expect(Resque).to receive(:enqueue).with(
        CreateEventJob,
        event_type: Event::EventTypes::EMPLOYER_UPDATED,
        aggregate_id: employer.id,
        data: {
          name: "Portiko",
          location: "Columbus, O-H-I-O",
          bio: "We are a really good welding company",
          logo_url: "https://www.blocktrain.com/logo.jpeg"
        },
        occurred_at: be_present,
        metadata: {}
      )

      subject
    end
  end
end
