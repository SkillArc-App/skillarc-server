module Admin
  def admin_authorize
    unless current_user.user_roles.any? { |ur| ur.role.name == 'admin' }
      render json: { error: 'Not authorized' }, status: :unauthorized
      nil
    end
  end
end
