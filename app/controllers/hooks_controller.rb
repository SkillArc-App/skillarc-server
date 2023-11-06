class HooksController < ApplicationController
  before_action :set_webhook, only: [:event]

  def event
    # return not found if the webhook is not found
    unless webhook
      render json: { success: false }, status: :not_found
      return
    end

    HookService.new.create_notification(
      email: params[:email],
      title: params[:title],
      body: params[:body],
      url: params[:url],
    )

    render json: { success: true }
  end
  
  private

  attr_reader :webhook

  def set_webhook
    @webhook = Webhook.find(params[:id])
  end
end
