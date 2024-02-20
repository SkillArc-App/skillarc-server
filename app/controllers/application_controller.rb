class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |_|
    render json: { error: 'Resource not found' }, status: :not_found
  end
end
