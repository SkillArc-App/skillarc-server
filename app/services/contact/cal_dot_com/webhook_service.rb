module Contact
  module CalDotCom
    class WebhookService
      def self.handle_webhook(webhook)
        EventService.create!(
          event_schema: Events::CalWebhookRecieved::V1,
          integration: "cal.com",
          data: Events::CalWebhookRecieved::Data::V1.new(
            cal_trigger_event_type: webhook["triggerEvent"],
            payload: webhook["payload"]
          ),
          occurred_at: webhook["createdAt"]
        )
      end
    end
  end
end
