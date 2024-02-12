module Coaches
  class RecommendationService < EventConsumer
    def self.handled_events
      [
        Events::JobRecommended::V1
      ].freeze
    end

    def self.handle_event(message, *_params)
      case message.event_schema
      when Events::JobRecommended::V1
        handle_job_recommended(message)
      end
    end

    def self.reset_for_replay; end

    class << self
      private

      def handle_job_recommended(message)
        job_id = message.data.job_id

        csc = CoachSeekerContext.find_by(seeker_id: message.aggregate_id)

        Contact::SmsService.new(csc.phone_number).send_message(
          "From your SkillArc career coach. Check out this job: #{ENV.fetch('FRONTEND_URL', nil)}/jobs/#{job_id}"
        )
      end
    end
  end
end
