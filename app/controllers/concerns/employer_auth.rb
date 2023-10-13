module EmployerAuth
  def employer_authorize
    unless (@recruiter = current_user.recruiter)
      render json: { error: 'Not authorized' }, status: 401
      return
    end
  end

  private

  attr_reader :recruiter
end
