# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_strict_schema_validation = true

  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('openapi').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/openapi.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer
          }
        },
        schemas: {
          applicant: {
            type: :object,
            properties: {
              id: {
                type: :id,
                format: :uuid
              },
              jobId: {
                type: :id,
                format: :uuid
              },
              seekerId: {
                type: :id,
                format: :uuid
              },
              createdAt: {
                type: :string,
                format: 'date-time'
              },
              updatedAt: {
                type: :string,
                format: 'date-time'
              }
            }
          },
          employer_applicants: {
            type: :object,
            properties: {
              id: {
                type: :id,
                format: :uuid
              },
              jobId: {
                type: :id,
                format: :uuid
              },
              chatEnabled: {
                type: :boolean
              },
              createdAt: {
                type: :string,
                format: 'date-time'
              },
              jobName: {
                type: :string
              },
              firstName: {
                type: :string
              },
              lastName: {
                type: :string
              },
              email: {
                type: :string,
                format: :email
              },
              phoneNumber: {
                type: :string,
                nullable: true
              },
              profileLink: {
                type: :string
              },
              programs: {
                type: :array
              },
              statusReasons: {
                type: :array,
                items: {
                  type: :string
                }
              },
              status: {
                type: :string
              }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
