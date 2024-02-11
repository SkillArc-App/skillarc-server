require 'rails_helper'

RSpec.describe Coaches::RecommendationService do
  let(:job_recommended) { build(:events__message, :job_recommended, aggregate_id: seeker_id, data: Events::JobRecommended::Data::V1.new(job_id:, coach_id:)) }

  let(:job_id) { SecureRandom.uuid }
  let(:coach_id) { SecureRandom.uuid }

  let!(:coach_seeker_context) { create(:coaches__coach_seeker_context, phone_number: "1234567890", seeker_id:) }
  let(:seeker_id) { SecureRandom.uuid }

  it_behaves_like "an event consumer"

  context "JobRecommended" do
    it "calls the Sms Gateway" do
      expect(Contact::SmsService).to receive(:new).with("1234567890").and_call_original

      expect_any_instance_of(Contact::SmsService).to receive(:send_message).with(
        "From your SkillArc career coach. Check out this job: #{ENV['FRONTEND_URL']}/jobs/#{job_id}"
      ).and_call_original

      described_class.handle_event(job_recommended)
    end
  end
end
