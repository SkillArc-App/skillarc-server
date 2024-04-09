class SeekerChats
  include MessageEmitter

  def initialize(user)
    @user = user
  end

  def send_message(applicant_id:, message:)
    applicant_chat = ApplicantChat.find_or_create_by!(applicant_id:)

    applicant_chat.messages.create!(user:, message:)

    message_service.create!(
      schema: Events::ChatMessageSent::V1,
      job_id: applicant_chat.applicant.job.id,
      data: {
        applicant_id: applicant_chat.applicant.id,
        seeker_id: applicant_chat.applicant.seeker_id,
        from_user_id: applicant_chat.applicant.seeker.user.id,
        employer_name: applicant_chat.applicant.job.employer.name,
        employment_title: applicant_chat.applicant.job.employment_title,
        message:
  }
    )
  end

  def get
    ApplicantChat
      .includes(messages: %i[user read_receipts], applicant: { seeker: :user, job: :employer })
      .references(:messages, applicant: { seeker: :user, job: :employer })
      .where(applicants: { seeker: { users_seekers: { id: user.id } } }).map do |applicant_chat|
        job = applicant_chat.applicant.job
        {
          id: applicant_chat.applicant.id,
          name: "#{job.employer.name} - #{job.employment_title}",
          updatedAt: applicant_chat.messages.last_created&.created_at || applicant_chat.created_at,
          messages: applicant_chat.messages.sort_by(&:created_at).map do |message|
            {
              id: message.id,
              text: message.message,
              isUser: message.user == user,
              isRead: message.read_receipts.any? { |read_receipt| read_receipt.user == user },
              sender: "#{message.user.first_name} #{message.user.last_name}"
            }
          end
        }
      end
  end

  def mark_read(applicant_id:)
    ApplicantChat
      .includes(messages: %i[user read_receipts], applicant: { seeker: :user, job: :employer })
      .references(:messages, applicant: { seeker: :user, job: :employer })
      .where(applicants: { id: applicant_id })
      .find_each do |applicant_chat|
        applicant_chat.messages.each do |message|
          message.read_receipts.find_or_create_by!(user:)
        end
      end
  end

  private

  attr_reader :user
end
