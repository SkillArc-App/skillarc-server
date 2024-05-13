module JobOrders
  class JobOrdersQuery
    def self.all_orders
      JobOrder.includes(:job).all.map do |job_order|
        serialize_job_order_summary(job_order)
      end
    end

    def self.find_order(id)
      serialize_job_order(JobOrder.find(id))
    end

    class << self
      private

      def serialize_job_order_summary(job_order)
        {
          id: job_order.id,
          employment_title: job_order.job.employment_title,
          employer_name: job_order.job.employer_name,
          opened_at: job_order.opened_at,
          closed_at: job_order.opened_at,
          order_count: job_order.order_count,
          hire_count: job_order.hire_count,
          recommended_count: job_order.recommended_count,
          status: job_order.status
        }
      end

      def serialize_job_order(job_order)
        candidates = job_order.candidates
        applications = job_order.job.applications

        # To be clear I know this is going to be very inefficient
        # I'll follow up with a performance pass t
        {
          **serialize_job_order_summary(job_order),
          candidates: candidates.map do |candidate|
            {
              id: candidate.id,
              first_name: candidate.seeker.first_name,
              last_name: candidate.seeker.last_name,
              phone_number: candidate.seeker.phone_number,
              email: candidate.seeker.email,
              applied_at: applications.detect { |application| application.seeker == candidate.seeker }&.occurred_at,
              recommended_at: nil, # TODO
              status: candidate.status,
              seeker_id: candidate.seeker_id
            }
          end,
          applications: applications.map do |application|
            {
              first_name: application.seeker.first_name,
              last_name: application.seeker.last_name,
              phone_number: application.seeker.phone_number,
              email: application.seeker.email,
              applied_at: application.opened_at,
              recommended_at: nil, # TODO
              status: application.status,
              seeker_id: application.seeker_id
            }
          end,
          notes: [] # TODO
        }
      end
    end
  end
end
