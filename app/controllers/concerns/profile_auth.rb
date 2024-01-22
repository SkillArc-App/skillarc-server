module ProfileAuth
  include CoachAuth

  def profile_editor_authorize
    return if profile_editor?

    render json: { error: 'Not authorized' }, status: :unauthorized
    nil
  end

  def profile_editor?
    return false unless current_user
    return false unless profile

    profile.user_id == current_user.id || coach?
  end
end
