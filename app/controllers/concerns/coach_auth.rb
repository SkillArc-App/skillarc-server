module CoachAuth
  def coach_authorize
    return if coach?

    render json: { error: 'Not authorized' }, status: :unauthorized
    nil
  end

  def coach?
    return false unless current_user

    current_user.roles.any? { |r| r.name == Role::Types::COACH }
  end
end
