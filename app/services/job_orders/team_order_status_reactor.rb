module JobOrders
  class TeamOrderStatusReactor < MessageReactor
    def can_replay?
      false
    end

    on_message ::Events::DayElapsed::V2 do |message|
      # Don't bother on the weekened
      return if message.data.day_of_week == ::Events::DayElapsed::Data::DaysOfWeek::SATURDAY
      return if message.data.day_of_week == ::Events::DayElapsed::Data::DaysOfWeek::SUNDAY

      # Determine who owns which order status
      team_status_owners = OrderStatus::ALL.each_with_object({}) do |order_status, owners|
        owner = ::Projectors::Aggregates::GetLast.project(
          aggregate: Aggregates::OrderStatus.new(order_status:),
          schema: Events::TeamResponsibleForStatus::V1
        )

        next if owner.nil?

        owners[order_status] = owner.data.team_id
      end

      return if team_status_owners.empty?

      # Grab each job order following into an owned status
      # grab some meta data for a message
      team_job_owners = {}

      JobOrder.includes(:job).find_each do |job_order|
        team_owner_id = team_status_owners[job_order.status]
        next if team_owner_id.nil?

        team_job_owners[team_owner_id] ||= []
        team_job_owners[team_owner_id] << {
          id: job_order.id,
          status: job_order.status,
          employer_name: job_order.job.employer_name,
          employment_title: job_order.job.employment_title,
          opened_at: job_order.opened_at
        }
      end

      team_job_owners.each do |team_id, job_orders|
        message_service.create!(
          trace_id: message.trace_id,
          task_id: SecureRandom.uuid,
          schema: ::Commands::ScheduleTask::V1,
          data: {
            # At some point we're going to want this time picking to
            # be more rebust
            execute_at: message.data.date.in_time_zone("Eastern Time (US & Canada)") + 8.hours,
            command: message_service.build(
              trace_id: message.trace_id,
              team_id:,
              schema: Teams::Commands::SendSlackMessage::V1,
              data: {
                message: craft_slack_message(job_orders)
              }
            )
          },
          metadata: {
            requestor_type: Requestor::Kinds::SERVER,
            requestor_id: nil
          }
        )
      end
    end

    private

    def craft_slack_message(job_orders)
      message = "Good morning team! The following job orders are active an assigned here.\n"
      job_orders.sort_by { |order| order[:opened_at] }.each do |job_order|
        message += "* <#{ENV.fetch('FRONTEND_URL', nil)}/orders/#{job_order[:id]}|#{job_order[:employer_name]}: #{job_order[:employment_title]}>: #{job_order[:status]}"
      end

      message
    end
  end
end
