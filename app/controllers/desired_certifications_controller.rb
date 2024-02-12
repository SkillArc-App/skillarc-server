class DesiredCertificationsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: %i[create destroy]
  before_action :set_job

  def create
    job.desired_certifications.create!(id: SecureRandom.uuid, master_certification_id: params[:master_certification_id])

    render json: { success: true }
  end

  def destroy
    desired_certification = job.desired_certifications.find(params[:id])

    desired_certification.destroy!

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
