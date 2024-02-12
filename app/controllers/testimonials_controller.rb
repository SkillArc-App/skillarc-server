class TestimonialsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize
  before_action :admin_authorize, only: %i[create destroy]
  before_action :set_job

  def create
    render json: Jobs::TestimonialService.create(
      job_id: job.id,
      **params.permit(:name, :title, :testimonial, :photo_url).to_h.symbolize_keys
    )
  end

  def destroy
    testimonial = job.testimonials.find(params[:id])

    Jobs::TestimonialService.destroy(testimonial)

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
