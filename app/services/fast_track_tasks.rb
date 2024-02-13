class FastTrackTasks
  def initialize(user)
    @user = user
  end

  def career
    return [] unless seeker?
    return [] unless onboarding_complete?

    save_3_jobs = {
      name: "Save 3 jobs",
      is_complete: user.saved_jobs.count >= 3,
      route: "/jobs"
    }

    apply_to_your_first_job = {
      name: "Apply to your first job",
      is_complete: !user.applied_jobs.empty?,
      route: "/jobs"
    }

    [save_3_jobs, apply_to_your_first_job]
  end

  def seeker
    return [] unless seeker?
    return [] unless onboarding_complete?

    if user.seeker.nil?
      return [
        { name: "Make your resume strong", is_complete: false, route: "/" },
        { name: "Meet your career coach", is_complete: false, route: "/" }
      ]
    end

    make_your_resume_strong = {
      name: "Make your resume strong",
      is_complete: ProfileCompleteness.new(user.seeker).status.result == "complete",
      route: "/profiles/#{user.seeker.id}"
    }

    [make_your_resume_strong]
  end

  private

  def onboarding_complete?
    user.onboarding_session&.completed_at
  end

  def seeker?
    !user.recruiter && !user.training_provider_profile
  end

  attr_reader :user
end
