module Coaches
  class RecommendationService < MessageConsumer
    def handled_messages
      [
        Events::JobRecommended::V1
      ].freeze
    end

    def handle_message(message, *_params)
      case message.schema
      when Events::JobRecommended::V1
        handle_job_recommended(message)
      end
    end

    def reset_for_replay; end

    private

    def handle_job_recommended(message)
      job_id = message.data.job_id

      csc = CoachSeekerContext.find_by(seeker_id: message.aggregate_id)
      return if csc&.phone_number.nil?

      CommandService.create!(
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
