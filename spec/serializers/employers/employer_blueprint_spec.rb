require "rails_helper"

RSpec.describe Employers::EmployerBlueprint do
  describe "#render" do
    subject do
      described_class.render(employer, view:)
    end

    let(:employer) { create(:employer) }

    context "default view" do
      let(:view) { :default }

      it "renders the id only" do
        expect(JSON.parse(subject)).to eq(
          {
            "id" => employer.id,
            "name" => employer.name,
            "logo_url" => employer.logo_url
          }
        )
      end
    end
  end
end
