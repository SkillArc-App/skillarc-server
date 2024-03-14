module Contact
  module CalDotCom
    class WebhookService
      extend EventEmitter

      def self.handle_webhook(webhook)
        event_service.create!(
          event_schema: Events::CalWebhookRecieved::V1,
          integration: "cal.com",
          data: Events::CalWebhookReceived::Data::V1.new(
            cal_trigger_event_type: webhook["triggerEvent"],
            payload: webhook["payload"]
          ),
          occurred_at: webhook["createdAt"]
        )
      end
    end
  end
end
