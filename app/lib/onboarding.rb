class Onboarding
  module Steps
    ALL = [
      START = "start".freeze,
      NAME = 'name'.freeze,
      RELIABILITY = 'reliability'.freeze,
      EMPLOYMENT = 'employment'.freeze,
      EDUCATION = "education".freeze,
      TRAINING = "training".freeze,
      OPPORTUNITIES = "opportunities".freeze,
      COMPLETE = "complete".freeze
    ].freeze
  end

  def initialize(message_service:, seeker_id:, user_id:, trace_id:)
    @seeker_id = seeker_id
    @trace_id = trace_id
    @user_id = user_id
    @seeker_reactor = Seekers::SeekerReactor.new(message_service:)
  end

  def update(responses:)
    update_name(retrieve_response_for(responses, "name")) if response_for?(responses, "name")
    update_reliability(retrieve_response_for(responses, "reliability")) if response_for?(responses, "reliability")
    update_experience(retrieve_response_for(responses, "experience")) if response_for?(responses, "experience")
    update_education(retrieve_response_for(responses, "education")) if response_for?(responses, "education")
    update_training_provider(retrieve_response_for(responses, "training_provider")) if response_for?(responses, "training_provider")
    update_other(retrieve_response_for(responses, "other")) if response_for?(responses, "other")
    update_interests(retrieve_response_for(responses, "opportunity_interests")) if response_for?(responses, "opportunity_interests")
  end

  private

  attr_reader :seeker_reactor, :user_id, :seeker_id, :trace_id

  def update_name(name_response)
    seeker_reactor.basic_info_added(
      seeker_id:,
      trace_id:,
      user_id:,

      first_name: name_response["first_name"],
      last_name: name_response["last_name"],
      phone_number: name_response["phone_number"],
      date_of_birth: Date.strptime(name_response["date_of_birth"], "%m/%d/%Y")
    )
  end

  def update_reliability(reliabilities)
    seeker_reactor.reliability_added(
      seeker_id:,
      trace_id:,
      reliabilities: reliabilities.map { |r| map_reliabilities(r) }
    )
  end

  def map_reliabilities(reliability)
    case reliability
    when "I've had or currently have a job"
      Reliability::JOB
    when "I've attended a Training Program"
      Reliability::TRAINING_PROGRAM
    when 'I have a High School Diploma / GED'
      Reliability::EDUCATION
    end
  end

  def update_experience(work_responses)
    work_responses.each do |wr|
      seeker_reactor.experience_added(
        seeker_id:,
        trace_id:,

        organization_name: wr["company"],
        position: wr["position"],
        start_date: wr["start_date"],
        end_date: wr["end_date"],
        is_current: wr["current"],
        description: wr["description"]
      )
    end
  end

  def update_education(education_responses)
    education_responses.each do |er|
      seeker_reactor.education_experience_added(
        seeker_id:,
        trace_id:,

        organization_name: er["org"],
        title: er["title"],
        activities: er["activities"],
        graduation_date: er["grad_year"],
        gpa: er["gpa"]
      )
    end
  end

  def update_training_provider(tp_responses)
    tp_responses.each do |tr|
      seeker_reactor.seeker_training_provider_added(
        seeker_id:,
        trace_id:,
        user_id:,
        program_id: nil,

        training_provider_id: tr
      )
    end
  end

  def update_other(other_responses)
    other_responses.each do |oth_r|
      seeker_reactor.personal_experience_added(
        seeker_id:,
        trace_id:,

        activity: oth_r["activity"],
        description: oth_r["learning"],
        start_date: oth_r["start_date"],
        end_date: oth_r["end_date"]
      )
    end
  end

  def update_interests(opportunity_interests_response)
    seeker_reactor.professional_interests_added(
      seeker_id:,
      trace_id:,

      interests: opportunity_interests_response
    )
  end

  def retrieve_response_for(responses, kind)
    responses.dig(kind, "response")
  end

  def response_for?(responses, kind)
    !responses.dig(kind, "response").nil?
  end
end
