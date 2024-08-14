module Industries
  class IndustriesAggregator < MessageConsumer
    def reset_for_replay
      Industry.delete_all
    end

    on_message Events::IndustriesSet::V1 do |message|
      Industry.delete_all
      Industry.create!(industries: message.data.industries)
    end
  end
end
