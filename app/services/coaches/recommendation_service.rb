module Coaches
  class RecommendationService < MessageConsumer
    def reset_for_replay; end

    on_message Events::JobRecommended::V2 do |message|
      job_id = message.data.job_id

      csc = CoachSeekerContext.find(message.aggregate_id)
      return if csc&.phone_number.nil?

      command_service.create!(
        command_schema: Commands::SendSms::V1,
        seeker_id: csc.seeker_id,
        trace_id: message.trace_id,
        data: Commands::SendSms::Data::V1.new(
          phone_number: csc.phone_number,
          message: "From your SkillArc career coach. Check out this job: #{ENV.fetch('FRONTEND_URL', nil)}/jobs/#{job_id}"
        )
      )
    end
  end
end
