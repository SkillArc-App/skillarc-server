module JobOrders
  module Aggregates
    class JobOrder < Core::Stream
      id_name :job_order_id
    end
  end
end
