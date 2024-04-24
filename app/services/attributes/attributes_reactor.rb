module Attributes
  class AttributesReactor < MessageConsumer
    def reset_for_replay; end

    def create(attribute_id:, name:, description:, set:, default:)
      message_service.create!(
        schema: Events::AttributeCreated::V1,
        attribute_id:,
        data: {
          name:,
          description:,
          set:,
          default:
        }
      )
    end

    def update(attribute_id:, name:, description:, set:, default:)
      message_service.create!(
        schema: Events::AttributeUpdated::V1,
        attribute_id:,
        data: {
          name:,
          description:,
          set:,
          default:
        }
      )
    end

    def destroy(attribute_id:)
      message_service.create!(
        schema: Events::AttributeDeleted::V1,
        attribute_id:,
        data: Messages::Nothing
      )
    end
  end
end
