require 'rails_helper'

RSpec.describe "Testimonials", type: :request do
  describe "POST /create" do
    subject { post job_testimonials_path(job_id: job.id), params:, headers: }

    include_context "admin authenticated"

    let(:params) do
      {
        name: "Tom",
        testimonial: "This is a testimonial",
        title: "CEO",
        photo_url: "image.png"
      }
    end
    let(:job) { create(:job) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates a testimonial" do
      expect { subject }.to change(Testimonial, :count).by(1)
    end
  end

  describe "DELETE /destroy" do
    subject { delete job_testimonial_path(job_id: job.id, id: testimonial.id), headers: }

    include_context "admin authenticated"

    let(:job) { create(:job) }
    let!(:testimonial) { create(:testimonial, job:) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "deletes the testimonial" do
      expect { subject }.to change(Testimonial, :count).by(-1)
    end
  end
end
