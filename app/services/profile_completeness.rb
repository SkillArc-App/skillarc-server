class ProfileCompleteness
  Result = Struct.new(:result, :missing)

  def initialize(profile)
    @profile = profile
  end

  def status
    missing = []

    missing << "education" if missing_education?
    missing << "work" if missing_work?

    Result.new(missing.empty? ? "complete" : "incomplete", missing)
  end

  private

  def missing_education?
    profile.education_experiences.empty?
  end

  def missing_work?
    profile.other_experiences.empty?
  end

  attr_reader :profile
end