module JobOrders
  class JobOrdersReactor < MessageConsumer
    def reset_for_replay
      # Stuff
    end

    on_message Events::JobCreated::V3 do |message|
      # Create job order
    end

    on_message Events::JobOrderAdded::V1 do |message|
      # Check if we've meet the job order
    end

    on_message Events::JobOrderCandidateAdded::V1 do |message|
      # Check if we've meet the job order
    end

    on_message Events::JobOrderCandidateHired::V1 do |message|
      # Check if we've meet the job order
    end

    on_message Events::JobOrderCandidateRescinded::V1 do |message|
      # Check if we've meet the job order
    end
  end
end
