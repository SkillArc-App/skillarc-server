module CoachAuth
  def coach_authorize
    return if is_coach?

    render json: { error: 'Not authorized' }, status: :unauthorized
    nil
  end

  def is_coach?
    return false unless current_user

    current_user.roles.any? { |r| r.name == Role::Types::COACH }
  end
end
