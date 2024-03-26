require 'rails_helper'

RSpec.describe Coaches::RecommendationService do
  let(:job_recommended) { build(:message, :job_recommended, version: 2, aggregate_id: seeker_context_id, data: Events::JobRecommended::Data::V1.new(job_id:, coach_id:)) }

  let(:job_id) { SecureRandom.uuid }
  let(:coach_id) { SecureRandom.uuid }

  let!(:coach_seeker_context) { create(:coaches__coach_seeker_context, phone_number: "1234567890", seeker_id:) }
  let(:seeker_context_id) { coach_seeker_context.context_id }
  let(:seeker_id) { SecureRandom.uuid }

  it_behaves_like "a message consumer"

  context "JobRecommended" do
    it "does emit an SEND_SMS command" do
      expect_any_instance_of(CommandService)
        .to receive(:create!)
        .with(
          command_schema: Commands::SendSms::V1,
          seeker_id:,
          trace_id: job_recommended.trace_id,
          data: Commands::SendSms::Data::V1.new(
            phone_number: "1234567890",
            message: "From your SkillArc career coach. Check out this job: #{ENV.fetch('FRONTEND_URL', nil)}/jobs/#{job_id}"
          )
        )
        .and_call_original

      described_class.new(command_service: CommandService.new).handle_message(job_recommended)
    end

    context "when the phone number is not on the coach seekers context" do
      let!(:coach_seeker_context) { create(:coaches__coach_seeker_context, phone_number: nil, seeker_id:) }

      it "does not emit an SEND_SMS command" do
        expect_any_instance_of(CommandService)
          .not_to receive(:create!)

        described_class.new.handle_message(job_recommended)
      end
    end
  end
end
