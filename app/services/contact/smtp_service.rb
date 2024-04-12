module Contact
  class SmtpService < MessageConsumer
    on_message Commands::NotifyEmployerOfApplicant::V1 do |message|
      EmployerApplicantNotificationMailer.with(message:).notify_employer.deliver_now
      emit_smtp_sent_event(message)
    end

    on_message Commands::SendWeeklyEmployerUpdate::V1 do |message|
      EmployerWeeklyMailer.with(message:).applicants.deliver_now
      emit_smtp_sent_event(message)
    end

    private

    def emit_smtp_sent_event(message)
      message_service.create!(
        schema: Events::SmtpSent::V1,
        contact: message.data.recepent_email,
        trace_id: message.trace_id,
        data: {
          email: message.data.recepent_email,
          template: EmployerWeeklyMailer.class.to_s,
          template_data: message.data.serialize
        }
      )
    end
  end
end
