module Admin
  class AttributesController < AdminController
    include MessageEmitter

    def index
      render json: Attributes::AttributesQuery.all
    end

    def create
      attribute_id = SecureRandom.uuid
      name = params[:name]
      set = params[:set]
      default = params[:default]
      description = params[:description]

      with_message_service do
        message_service.create!(
          schema: Attributes::Commands::Create::V1,
          trace_id: request.request_id,
          attribute_id:,
          data: {
            machine_derived: false,
            name:,
            description:,
            set:,
            default:
          },
          metadata: requestor_metadata
        )
      end

      head :created
    end

    def update
      attribute_id = params[:id]
      name = params[:name]
      set = params[:set]
      default = params[:default]
      description = params[:description]

      with_message_service do
        message_service.create!(
          schema: Attributes::Commands::Create::V1,
          trace_id: request.request_id,
          attribute_id:,
          data: {
            machine_derived: false,
            name:,
            description:,
            set:,
            default:
          },
          metadata: requestor_metadata
        )
      end
    end

    def destroy
      attribute_id = params[:id]

      with_message_service do
        message_service.create!(
          schema: Attributes::Commands::Delete::V1,
          trace_id: request.request_id,
          attribute_id:,
          data: Core::Nothing,
          metadata: requestor_metadata
        )
      end
    end
  end
end
