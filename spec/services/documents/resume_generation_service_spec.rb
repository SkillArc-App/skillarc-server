require 'rails_helper'

RSpec.describe Documents::ResumeGenerationService do
  describe ".generate_from_command" do
    subject { described_class.generate_from_command(message:) }

    let(:message) do
      build(
        :message,
        schema: Documents::Commands::GenerateResume::V1,
        data: {
          person_id: SecureRandom.uuid,
          anonymized: true,
          bio: nil,
          work_experiences: [],
          education_experiences: [],
          document_kind: Documents::DocumentKind::PDF,
          first_name: "Skillz",
          last_name: "Bot",
          page_limit: 1
        }
      )
    end

    it "creates a pdf document" do
      expect(subject).to be_a(String)
    end
  end
end
