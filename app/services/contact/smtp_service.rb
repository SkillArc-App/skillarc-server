module Contact
  class SmtpService < EventConsumer
    def handled_events
      [
        Commands::NotifyEmployerOfApplicant::V1,
        Commands::SendWeeklyEmployerUpdate::V1
      ]
    end

    def handle_message(message, *_params)
      case message.schema
      when Commands::NotifyEmployerOfApplicant::V1
        handle_notify_employer_of_applicant(message)
      when Commands::SendWeeklyEmployerUpdate::V1
        handle_send_weekly_employer_update(message)
      end
    end

    private

    def handle_notify_employer_of_applicant(message)
      EmployerApplicantNotificationMailer.with(message:).notify_employer.deliver_now
      emit_smtp_sent_event(message)
    end

    def handle_send_weekly_employer_update(message)
      EmployerWeeklyMailer.with(message:).applicants.deliver_now
      emit_smtp_sent_event(message)
    end

    def emit_smtp_sent_event(message)
      EventService.create!(
        event_schema: Events::SmtpSent::V1,
        contact: message.data.recepent_email,
        trace_id: message.trace_id,
        data: Events::SmtpSent::Data::V1.new(
          email: message.data.recepent_email,
          template: EmployerWeeklyMailer.class.to_s,
          template_data: message.data.to_h
        )
      )
    end
  end
end
