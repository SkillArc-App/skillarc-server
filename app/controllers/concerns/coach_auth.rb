module CoachAuth
  def coach_authorize
    unless current_user.roles.any? { |r| r.name == Role::Types::COACH }
      render json: { error: 'Not authorized' }, status: 401
      return
    end
  end
end