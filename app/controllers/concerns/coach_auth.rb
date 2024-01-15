module CoachAuth
  def coach_authorize
    return if current_user.roles.any? { |r| r.name == Role::Types::COACH }

    render json: { error: 'Not authorized' }, status: :unauthorized
    nil
  end
end
