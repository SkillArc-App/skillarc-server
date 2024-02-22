require 'rails_helper'

RSpec.describe Coaches::RecommendationService do
  let(:job_recommended) { build(:message, :job_recommended, aggregate_id: seeker_id, data: Events::JobRecommended::Data::V1.new(job_id:, coach_id:)) }

  let(:job_id) { SecureRandom.uuid }
  let(:coach_id) { SecureRandom.uuid }

  let!(:coach_seeker_context) { create(:coaches__coach_seeker_context, phone_number: "1234567890", seeker_id:) }
  let(:seeker_id) { SecureRandom.uuid }

  it_behaves_like "an event consumer"

  context "JobRecommended" do
    it "calls the Sms Gateway" do
      expect(CommandService)
        .to receive(:create!)
        .with(
          command_schema: Commands::SendSms::V1,
          aggregate_id: coach_seeker_context.seeker_id,
          data: Commands::SendSms::Data::V1.new(
            phone_number: "1234567890",
            message: "From your SkillArc career coach. Check out this job: #{ENV.fetch('FRONTEND_URL', nil)}/jobs/#{job_id}"
          )
        )
        .and_call_original

      described_class.new.handle_message(job_recommended)
    end
  end
end
