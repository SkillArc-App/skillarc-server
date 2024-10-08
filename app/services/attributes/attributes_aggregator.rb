module Attributes
  class AttributesAggregator < MessageConsumer
    def reset_for_replay
      Attribute.delete_all
    end

    on_message Events::Created::V4, :sync do |message|
      Attribute.create!(
        id: message.stream.attribute_id,
        name: message.data.name,
        description: message.data.description,
        machine_derived: message.data.machine_derived,
        set: message.data.set.to_h { |kvp| [kvp.key, kvp.value] },
        default: message.data.default.to_h { |kvp| [kvp.key, kvp.value] }
      )
    end

    on_message Events::Updated::V3, :sync do |message|
      attribute = Attribute.find(message.stream.attribute_id)
      attribute.update!(
        name: message.data.name,
        description: message.data.description,
        set: message.data.set.to_h { |kvp| [kvp.key, kvp.value] },
        default: message.data.default.to_h { |kvp| [kvp.key, kvp.value] }
      )
    end

    on_message Events::Deleted::V2, :sync do |message|
      Attribute.find(message.stream.attribute_id).destroy!
    end
  end
end
