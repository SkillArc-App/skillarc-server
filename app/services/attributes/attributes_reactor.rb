module Attributes
  class AttributesReactor < MessageReactor
    def create(attribute_id:, name:, description:, set:, default:)
      message_service.create!(
        schema: Events::Created::V2,
        attribute_id:,
        data: {
          machine_derived: false,
          name:,
          description:,
          set:,
          default:
        }
      )
    end

    def update(attribute_id:, name:, description:, set:, default:)
      message_service.create!(
        schema: Events::Updated::V1,
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
        schema: Events::Deleted::V1,
        attribute_id:,
        data: Core::Nothing
      )
    end
  end
end
