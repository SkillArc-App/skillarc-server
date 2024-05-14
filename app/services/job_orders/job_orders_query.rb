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

        {
          **serialize_job_order_summary(job_order),
          candidates: candidates.map do |candidate|
            {
              id: candidate.id,
              first_name: candidate.seeker.first_name,
              last_name: candidate.seeker.last_name,
              phone_number: candidate.seeker.phone_number,
              email: candidate.seeker.email,
              applied_at: candidate.applied_at,
              recommended_at: nil, # TODO
              status: candidate.status,
              seeker_id: candidate.seeker_id
            }
          end,
          notes: [] # TODO
        }
      end
    end
  end
end
