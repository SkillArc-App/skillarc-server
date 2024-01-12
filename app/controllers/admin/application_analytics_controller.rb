module Admin
  class ApplicationAnalyticsController < ApplicationController
    include Secured
    include Admin

    before_action :authorize, unless: -> { Rails.env.development? }

    def index
      application_analytics = ApplicationAnalytics.new

      average_status_times = application_analytics.average_status_times
      current_status_times = application_analytics.current_status_times

      render json: {
        averageStatusTimes: average_status_times,
        currentStatusTimes: current_status_times
      }
    end
  end
end
