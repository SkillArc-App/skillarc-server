class TestimonialsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: [:create, :destroy]
  before_action :set_job

  def create
    testimonial = job.testimonials.create!(
      **params.permit(:name, :title, :testimonial, :photo_url),
      id: SecureRandom.uuid
    )

    render json: testimonial
  end

  def destroy
    testimonial = job.testimonials.find(params[:id])

    testimonial.destroy!

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
