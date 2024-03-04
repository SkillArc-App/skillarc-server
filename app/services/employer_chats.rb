class EmployerChats
  Recruiter = Struct.new(:user, :employer_id)

  def initialize(recruiter)
    @recruiter = recruiter
  end

  def get
    ApplicantChat
      .includes(messages: :user, applicant: { seeker: :user, job: :employer })
      .references(:messages, applicant: { seeker: :user, job: :employer })
      .where(jobs: { employers: { id: recruiter.employer_id } }).map do |applicant_chat|
      applicant_user = applicant_chat.applicant.seeker.user

      {
        id: applicant_chat.applicant.id,
        name: "#{applicant_user.first_name} #{applicant_user.last_name} - #{applicant_chat.applicant.job.employment_title}",
        updatedAt: applicant_chat.messages.last_created&.created_at || applicant_chat.created_at,
        messages: applicant_chat.messages.sort_by(&:created_at).map do |message|
          {
            id: message.id,
            text: message.message,
            isUser: message.user == recruiter.user,
            isRead: message.read_receipts.any? { |read_receipt| read_receipt.user == recruiter.user },
            sender: "#{message.user.first_name} #{message.user.last_name}"
          }
        end
      }
    end
  end

  def mark_read(applicant_id:)
    ApplicantChat
      .includes(messages: :user, applicant: { seeker: :user, job: :employer })
      .references(:messages, applicant: { seeker: :user, job: :employer })
      .where(applicants: { id: applicant_id })
      .find_each do |applicant_chat|
        applicant_chat.messages.each do |message|
          message.read_receipts.find_or_create_by!(user: recruiter.user)
        end
      end
  end

  def send_message(applicant_id:, message:)
    applicant_chat = ApplicantChat.find_or_create_by!(applicant_id:)

    applicant_chat.messages.create!(user: recruiter.user, message:)

    EventService.create!(
      event_schema: Events::ChatMessageSent::V1,
      job_id: applicant_chat.applicant.job_id,
      data: Events::ChatMessageSent::Data::V1.new(
        applicant_id: applicant_chat.applicant.id,
        seeker_id: applicant_chat.applicant.seeker_id,
        from_user_id: recruiter.user.id,
        employer_name: applicant_chat.applicant.job.employer.name,
        employment_title: applicant_chat.applicant.job.employment_title,
        message:
      )
    )
  end

  def create(applicant_id:)
    applicant_chat = ApplicantChat.find_or_create_by!(applicant_id:)

    EventService.create!(
      event_schema: Events::ChatCreated::V1,
      job_id: applicant_chat.applicant.job.id,
      data: Events::ChatCreated::Data::V1.new(
        applicant_id: applicant_chat.applicant.id,
        seeker_id: applicant_chat.applicant.seeker_id,
        user_id: applicant_chat.applicant.seeker.user.id,
        employment_title: applicant_chat.applicant.job.employment_title
      )
    )
  end

  private

  attr_reader :recruiter
end
