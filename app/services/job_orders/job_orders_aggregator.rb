module JobOrders
  class JobOrdersAggregator < MessageConsumer
    def reset_for_replay
      # Stuff
    end

    on_message Events::JobCreated::V3 do |message|
      # Create job
    end

    on_message Events::JobUpdated::V2 do |message|
      # Update job
    end

    on_message Events::SeekerCreated::V1 do |message|
      # Create seeker
    end

    on_message Events::BasicInfoAdded::V1 do |message|
      # Update seeker
      # cheat and get email here
    end

    on_message Events::ApplicantStatusUpdated::V6 do |message|
      # Create application i.e suggestions
    end

    on_message Events::JobOrderAdded::V1 do |message|
      # upsert job order
    end

    on_message Events::JobOrderCandidateAdded::V1 do |message|
      # bump queued count
      # create canidate record
    end

    # Some other concept of we have recommended these canidates

    on_message Events::JobOrderCandidateHired::V1 do |message|
      # drop queued count
      # bump hired count
      # update canidate record
    end

    on_message Events::JobOrderCandidateRescinded::V1 do |message|
      # drop queued count
      # update canidate record
    end

    on_message Events::JobOrderStalled::V1 do |message|
      # update job order status
    end

    on_message Events::JobOrderFilled::V1 do |message|
      # update job order status
    end

    on_message Events::JobOrderNotFilled::V1 do |message|
      # update job order status
    end
  end
end
