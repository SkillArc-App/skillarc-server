class CareerPathsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: %i[create destroy]
  before_action :set_job
  before_action :set_path, only: %i[destroy up down]

  def up
    Jobs::CareerPathService.up(path)

    render json: { success: true }
  end

  def down
    Jobs::CareerPathService.down(path)

    render json: { success: true }
  end

  def create
    render json: Jobs::CareerPathService.create(
      job,
      **params.require(:career_path).permit(:title, :lower_limit, :upper_limit).to_h.symbolize_keys
    )
  end

  def destroy
    Jobs::CareerPathService.destroy(path)

    render json: { success: true }
  end

  private

  attr_reader :job, :path

  def set_job
    @job = Job.find(params[:job_id])
  end

  def set_path
    @path = job.career_paths.find(params[:id] || params[:career_path_id])
  end
end
