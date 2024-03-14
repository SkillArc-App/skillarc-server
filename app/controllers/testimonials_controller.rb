class TestimonialsController < ApplicationController
  include Secured
  include Admin
  include EventEmitter

  before_action :authorize
  before_action :admin_authorize, only: %i[create destroy]
  before_action :set_job

  def create
    with_event_service do
      render json: Jobs::TestimonialService.create(
        job_id: job.id,
        **params.permit(:name, :title, :testimonial, :photo_url).to_h.symbolize_keys
      )
    end
  end

  def destroy
    testimonial = job.testimonials.find(params[:id])

    with_event_service do
      Jobs::TestimonialService.destroy(testimonial)
    end

    render json: { success: true }
  end

  private

  attr_reader :job

  def set_job
    @job = Job.find(params[:job_id])
  end
end
