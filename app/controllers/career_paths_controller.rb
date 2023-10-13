class CareerPathsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: [:create, :destroy]
  before_action :set_job
  before_action :set_path, only: [:update, :destroy, :up, :down]

  def up
    return render json: { success: true } if path.order == 0

    path_above = job.career_paths.find_by(order: path.order - 1)

    ActiveRecord::Base.transaction do
      path_above.update!(order: path.order)
      path.update!(order: path.order - 1)
    end

    render json: { success: true }
  end

  def down
    return render json: { success: true } if path.order == job.career_paths.count - 1

    path_below = job.career_paths.find_by(order: path.order + 1)

    ActiveRecord::Base.transaction do
      path_below.update!(order: path.order)
      path.update!(order: path.order + 1)
    end

    render json: { success: true }
  end

  def create
    path = job.career_paths.new(**params.require(:career_path).permit(:title, :lower_limit, :upper_limit), id: SecureRandom.uuid)

    path.order = job.career_paths.count

    path.save!

    render json: path
  end

  def destroy
    paths = job.career_paths.where('"order" > ?', path.order)

    ActiveRecord::Base.transaction do
      paths.each do |path|
        path.update!(order: path.order - 1)
      end

      path.destroy!
    end

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
