class EmployerChats
  Recruiter = Struct.new(:user, :employer_id)

  def initialize(recruiter)
    @recruiter = recruiter
  end

  def get
    ApplicantChat
      .includes(messages: :user, applicant: { profile: :user, job: :employer })
      .references(:messages, applicant: { profile: :user, job: :employer })
      .where(jobs: { employers: { id: recruiter.employer_id } }).map do |applicant_chat|
        applicant_user = applicant_chat.applicant.profile.user

        {
          id: applicant_chat.applicant.id,
          name: "#{applicant_user.first_name} #{applicant_user.last_name} - #{applicant_chat.applicant.job.employment_title}",
          updatedAt: applicant_chat.messages.last_created&.created_at || applicant_chat.created_at,
          messages: applicant_chat.messages.sort_by(&:created_at).map do |message|
            {
              id: message.id,
              text: message.message,
              isUser: message.user == recruiter.user,
              sender: "#{message.user.first_name} #{message.user.last_name}"
            }
          end
        }
      end
  end

  def send_message(applicant_id:, message:)
    applicant_chat = ApplicantChat.find_or_create_by!(applicant_id: applicant_id)

    applicant_chat.messages.create!(user: recruiter.user, message: message)

    Resque.enqueue(
      CreateEventJob,
      event_type: Event::EventTypes::CHAT_MESSAGE_SENT,
      aggregate_id: applicant_chat.applicant.job.id,
      data: {
        applicant_id: applicant_chat.applicant.id,
        profile_id: applicant_chat.applicant.profile.id,
        user_id: applicant_chat.applicant.profile.user.id,
        employment_title: applicant_chat.applicant.job.employment_title,
        message: message
      },
      metadata: {},
      occurred_at: Time.now
    )
  end

  def create(applicant_id:)
    applicant_chat = ApplicantChat.find_or_create_by!(applicant_id: applicant_id)

    Resque.enqueue(
      CreateEventJob,
      event_type: Event::EventTypes::CHAT_CREATED,
      aggregate_id: applicant_chat.applicant.job.id,
      data: {
        applicant_id: applicant_chat.applicant.id,
        profile_id: applicant_chat.applicant.profile.id,
        user_id: applicant_chat.applicant.profile.user.id,
        employment_title: applicant_chat.applicant.job.employment_title
      },
      metadata: {},
      occurred_at: Time.now
    )
  end

  private

  attr_reader :recruiter
end