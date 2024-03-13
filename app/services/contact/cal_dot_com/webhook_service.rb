module Contact
  module CalDotCom
    class WebhookService
      def self.handle_webhook(webhook)
        Webhook.create!(
          occurred_at: webhook["createdAt"],
          cal_dot_com_event_type: webhook["triggerEvent"],
          payload: webhook["payload"]
        )
      end
    end
  end
end
