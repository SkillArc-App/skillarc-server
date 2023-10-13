class JobPhotosController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: [:create, :destroy]
  before_action :set_job

  def create
    photo = job.job_photos.create!(**params.require(:job_photo).permit(:photo_url), id: SecureRandom.uuid)

    render json: photo
  end

  def destroy
    photo = job.job_photos.find(params[:id])

    photo.destroy!

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
