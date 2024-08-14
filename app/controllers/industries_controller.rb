class IndustriesController < SecureController
  def index
    render json: Industries::Industry.first&.industries || []
  end
end
