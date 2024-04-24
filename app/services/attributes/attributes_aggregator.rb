module Attributes
  class AttributesAggregator < MessageConsumer
    def reset_for_replay
      Attribute.delete_all
    end

    on_message Events::AttributeCreated::V1, :sync do |message|
      Attribute.create!(
        id: message.aggregate.attribute_id,
        name: message.data.name,
        set: message.data.set,
        default: message.data.default
      )
    end

    on_message Events::AttributeUpdated::V1, :sync do |message|
      attribute = Attribute.find(message.aggregate.attribute_id)
      attribute.update!(
        name: message.data.name,
        set: message.data.set,
        default: message.data.default
      )
    end

    on_message Events::AttributeDeleted::V1, :sync do |message|
      Attribute.find(message.aggregate.attribute_id).destroy!
    end
  end
end
