module Coaches
  class JobsController < CoachesController
    def index
      render json: CoachesQuery.all_jobs
    end
  end
end
