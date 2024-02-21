# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config| # rubocop:disable Metrics/BlockLength
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
                type: :string,
                format: :uuid
              },
              jobId: {
                type: :string,
                format: :uuid
              },
              seekerId: {
                type: :string,
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
                type: :string,
                format: :uuid
              },
              jobId: {
                type: :string,
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
          },
          seeker: {
            type: :object,
            properties: {
              id: {
                type: :string,
                format: :uuid
              },
              userId: {
                type: :string,
                format: :uuid
              },
              educationExperiences: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/education_experience'
                }
              },
              hiringStatus: {
                type: :string
              },
              industryInterests: {
                type: :array,
                items: {
                  type: :string
                }
              },
              isProfileEditor: {
                type: :boolean
              },
              otherExperiences: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/other_experience'
                }
              },
              personalExperience: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/personal_experience'
                }
              },
              profileSkills: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/profile_skill'
                }
              },
              reference: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/reference_with_training_provider'
                }
              },
              stories: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/stories'
                }
              },
              missingProfileItems: {
                type: :array,
                items: {
                  type: :string,
                  enum: %w[education work]
                }
              },
              user: {
                '$ref' => '#/components/schemas/user_with_training_provider'
              }
            }
          },
          coach_seeker: {
            type: :object,
            properties: {
              seekerId: {
                type: :string,
                format: :uuid
              },
              firstName: {
                type: :string,
                nullable: true
              },
              lastName: {
                type: :string,
                nullable: true
              },
              email: {
                type: :string,
                format: :email,
                nullable: true
              },
              phoneNumber: {
                type: :string,
                nullable: true
              },
              certifiedBy: {
                type: :string,
                nullable: true
              },
              skillLevel: {
                type: :string,
                nullable: true
              },
              lastActiveOn: {
                type: :string,
                format: 'date-time',
                nullable: true
              },
              lastContacted: {
                oneOf: [
                  {
                    type: :string,
                    format: 'date-time'
                  },
                  {
                    type: :string,
                    enum: ['Never']
                  }
                ],
                nullable: true
              },
              assignedCoach: {
                type: :string,
                nullable: true
              },
              barriers: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/seeker_barrier'
                }
              },
              stage: {
                type: :string,
                enum: ['seeker_created']
              },
              notes: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/seeker_note'
                }
              },
              applications: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/seeker_application'
                }
              },
              jobRecommendations: {
                type: :array,
                items: {
                  type: :string,
                  format: :uuid
                }
              }
            }
          },
          seeker_barrier: {
            type: :object,
            properties: {
              id: {
                type: :string,
                format: :uuid
              },
              name: {
                type: :string,
                format: :uuid
              }
            }
          },
          seeker_note: {
            type: :object,
            properties: {
              note: {
                type: :string
              },
              noteId: {
                type: :string,
                format: :uuid
              },
              noteTakenBy: {
                type: :string,
                nullable: true
              },
              date: {
                type: :string,
                format: 'date-time'
              }
            }
          },
          seeker_application: {
            type: :object,
            properties: {
              status: {
                type: :string
              },
              employerName: {
                type: :string
              },
              jobId: {
                type: :string,
                format: :uuid,
                nullable: true
              },
              employmentTitle: {
                type: :string,
                nullable: true
              }
            }
          },
          other_experience: {
            type: :object,
            properties: {
              id: {
                type: :string,
                format: :uuid
              },
              organizationName: {
                type: :string
              },
              position: {
                type: :string
              },
              startDate: {
                type: :string
              },
              endDate: {
                type: :string
              },
              isCurrent: {
                type: :boolean
              },
              description: {
                type: :string
              }
            }
          },
          education_experience: {
            type: :object,
            properties: {
              id: {
                type: :string,
                format: :uuid
              },
              organizationName: {
                type: :string,
                nullable: true
              },
              title: {
                type: :string,
                nullable: true
              },
              graduationDate: {
                type: :string,
                nullable: true
              },
              gpa: {
                type: :string,
                nullable: true
              },
              activities: {
                type: :string,
                nullable: true
              }
            }
          },
          personal_experience: {
            type: :object,
            properties: {
              id: {
                type: :string,
                format: :uuid
              },
              activity: {
                type: :string
              },
              startDate: {
                type: :string
              },
              endDate: {
                type: :string
              },
              description: {
                type: :string
              }
            }
          },
          profile_skill: {
            type: :object,
            properties: {
              id: {
                type: :string,
                format: :uuid
              },
              description: {
                type: :string,
                nullable: true
              },
              masterSkill: {
                '$ref' => '#/components/schemas/master_skill'
              }
            }
          },
          master_skill: {
            type: :object,
            properties: {
              id: {
                type: :string,
                format: :uuid
              },
              skill: {
                type: :string
              },
              type: {
                type: :string,
                enum: MasterSkill::SkillTypes::ALL
              }
            }
          },
          user: {
            type: :object,
            additionalProperties: true,
            properties: {
              id: {
                type: :string,
                format: :uuid
              },
              email: {
                type: :string,
                format: :email
              },
              firstName: {
                type: :string
              },
              lastName: {
                type: :string
              },
              zipCode: {
                type: :string,
                nullable: true
              },
              phoneNumber: {
                type: :string,
                nullable: true
              }
            }
          },
          user_with_training_provider: {
            allOf: [
              { '$ref' => '#/components/schemas/user' },
              {
                type: :object,
                additionalProperties: true,
                properties: {
                  seekerTrainingProviders: {
                    type: :array,
                    items: {
                      '$ref' => '#/components/schemas/seeker_training_provider'
                    }
                  }
                }
              }
            ]
          },
          seeker_training_provider: {
            type: :object,
            properties: {
              programId: {
                type: :string,
                format: :uuid
              },
              trainingProviderId: {
                type: :string,
                format: :uuid
              }
            }
          },
          reference: {
            type: :object,
            additionalProperties: true,
            properties: {
              referenceText: {
                type: :string
              }
            }
          },
          training_provider: {
            type: :object,
            properties: {
              id: {
                type: :string,
                format: :uuid
              },
              name: {
                type: :string,
                format: :uuid
              }
            }
          },
          reference_with_training_provider: {
            allOf: [
              {
                '$ref' => '#/components/schemas/reference'
              },
              {
                type: :object,
                additionalProperties: true,
                properties: {
                  trainingProvider: {
                    '$ref' => "#/components/schemas/training_provider"
                  },
                  authorUser: {
                    '$ref' => '#/components/schemas/user'
                  }
                }
              }
            ]
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
