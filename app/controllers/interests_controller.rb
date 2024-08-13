class InterestsController < SecureController
  def index
    render json: Interests::Interest.first&.interests || []
  end
end
