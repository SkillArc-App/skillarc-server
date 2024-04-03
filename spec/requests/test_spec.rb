require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Test", type: :request do
  path '/test/create_user' do
    post "Create test user" do
      tags 'Test'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      response '200', 'Create test user' do
        schema type: :object

        run_test!
      end
    end
  end

  path '/test/create_coach' do
    post "Create test coach" do
      tags 'Test'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      response '200', 'Create test user' do
        schema type: :object

        run_test!
      end
    end
  end

  path '/test/create_coach' do
    post "Create test coach" do
      tags 'Test'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      before do
        create(:role, name: Role::Types::COACH)
      end

      response '200', 'Create test coach' do
        schema type: :object

        run_test!
      end
    end
  end

  path '/test/create_seeker' do
    post "Create test seeker" do
      tags 'Test'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      response '200', 'Create test seeker' do
        schema type: :object

        run_test!
      end
    end
  end

  path '/test/create_job' do
    post "Create test job" do
      tags 'Test'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      response '200', 'Create test job' do
        schema type: :object

        run_test!
      end
    end
  end

  path '/test/create_recruiter_with_applicant' do
    post "Create test recruiter with applicant" do
      tags 'Test'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      response '200', 'Create test recruiter with applicant' do
        schema type: :object

        run_test!
      end
    end
  end

  path '/test/create_test_trainer_with_student' do
    post "Create test trainer with student" do
      tags 'Test'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      response '200', 'Create test trainer with student' do
        schema type: :object

        run_test!
      end
    end
  end

  path '/test/create_seeker_lead' do
    post "Create seeker lead" do
      tags 'Test'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      response '200', 'Create seeker lead' do
        schema type: :object

        run_test!
      end
    end
  end

  path '/test/create_active_seeker' do
    post "Create active seeker" do
      tags 'Test'
      produces 'application/json'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      response '200', 'Create active seeker' do
        schema type: :object

        run_test!
      end
    end
  end

  path '/test/assert_no_failed_jobs' do
    get "Assert job failure status" do
      tags 'Test'

      include_context "olive branch casing parameter"
      include_context "olive branch camelcasing"

      before do
        Resque::Failure.clear
      end

      response '204', 'No failed jobs' do
        run_test!
      end

      response '200', 'failed jobs' do
        schema type: :object,
               properties: {
                 exception: {
                   type: :string
                 },
                 message: {
                   type: :string
                 },
                 backtrace: {
                   type: :array,
                   items: {
                     type: :string
                   }
                 }
               }

        context "when there is one failure" do
          before do
            Resque::Failure.create(exception: StandardError.new)
          end

          run_test!
        end

        context "when there is multiple failures" do
          before do
            Resque::Failure.create(exception: StandardError.new)
            Resque::Failure.create(exception: StandardError.new)
          end

          run_test!
        end
      end
    end
  end
end
