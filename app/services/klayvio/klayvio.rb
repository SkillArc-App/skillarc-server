module Klayvio
  class Klayvio
    def application_status_updated(application_id:, email:, event_id:, employment_title:, employer_name:, occurred_at:, status:)
      data = event_data(
        event_type: 'Application Status Updated',
        email: email,
        time: occurred_at,
        event_id: event_id,
        event_properties: {
          application_id: application_id,
          employment_title: employment_title,
          employer_name: employer_name,
          status: status
        }
      )

      url = URI("https://a.klaviyo.com/api/events/")

      post(url, data)
    end

    def chat_message_sent(email:, event_id:, occurred_at:, applicant_id:, profile_id:, employment_title:, employer_name:)
      data = event_data(
        event_type: 'Chat Message Sent',
        email: email,
        time: occurred_at,
        event_id: event_id,
        event_properties: {
          applicant_id: applicant_id,
          profile_id: profile_id,
          user_id: user_id,
          employer_name: employer_name,
          employment_title: employment_title,
        }
      )

      url = URI("https://a.klaviyo.com/api/events/")

      post(url, data)
    end

    def job_saved(email:, event_id:, event_properties:, occurred_at:)
      data = event_data(
        event_type: 'Job Saved',
        email: email,
        time: occurred_at,
        event_id: event_id,
        event_properties: event_properties
      )

      url = URI("https://a.klaviyo.com/api/events/")

      post(url, data)
    end

    def met_with_career_coach_updated(email:, occurred_at:, event_id:, profile_properties:)
      data = event_data(
        event_type: 'Met With Career Coach Updated',
        email: email,
        time: occurred_at,
        event_id: event_id,
        profile_properties: profile_properties
      )

      url = URI("https://a.klaviyo.com/api/events/")

      post(url, data)
    end

    def user_signup(email:, occurred_at:, event_id:)
      data = event_data(event_type: 'User Signup', email: email, time: occurred_at, event_id: event_id)
  
      url = URI("https://a.klaviyo.com/api/events/")
  
      post(url, data)
    end

    def user_updated(email:, occurred_at:, event_id:, profile_properties:, profile_attributes:)
      data = event_data(
        event_type: 'User Updated',
        email: email,
        time: occurred_at,
        event_id: event_id,
        profile_properties: profile_properties,
        profile_attributes: profile_attributes
      )
  
      url = URI("https://a.klaviyo.com/api/events/")
  
      post(url, data)
    end

    def education_experience_entered(email:, occurred_at:, event_id:)
      data = event_data(event_type: 'Education Experience Entered', email: email, time: occurred_at, event_id: event_id)

      url = URI("https://a.klaviyo.com/api/events/")

      post(url, data)
    end

    def employer_invite_accepted(email:, occurred_at:, event_id:, profile_properties:)
      data = event_data(
        event_type: 'Employer Invite Accepted',
        email: email,
        time: occurred_at,
        event_id: event_id,
        profile_properties: profile_properties
      )

      url = URI("https://a.klaviyo.com/api/events/")

      post(url, data)
    end

    def training_provider_invite_accepted(email:, occurred_at:, event_id:, profile_properties:)
      data = event_data(
        event_type: 'Training Provider Invite Accepted',
        email: email,
        time: occurred_at,
        event_id: event_id,
        profile_properties: profile_properties
      )

      url = URI("https://a.klaviyo.com/api/events/")

      post(url, data)
    end

    def experience_entered(email:, occurred_at:, event_id:)
      data = event_data(event_type: 'Experience Entered', email: email, time: occurred_at, event_id: event_id)
  
      url = URI("https://a.klaviyo.com/api/events/")
  
      post(url, data)
    end

    def onboarding_complete(email:, occurred_at:, event_id:)
      data = event_data(event_type: 'Onboarding Complete', email: email, time: occurred_at, event_id: event_id)

      url = URI("https://a.klaviyo.com/api/events/")

      post(url, data)
    end

    private

    attr_reader :base_url

    def event_data(event_type:, email:, time:, event_id:, event_properties: {}, profile_properties: {}, profile_attributes: {})
      {
        "data": {
          "type": "event",
          "attributes": {
            "properties": {
              **event_properties
            },
            "metric": {
              "data": {
                "type": "metric",
                "attributes": {
                  "name": event_type
                }
              }
            },
            "profile": {
              "data": {
                "type": "profile",
                "attributes": {
                  **profile_attributes,
                  "email": email,
                  "properties": {
                    **profile_properties
                  }
                }
              }
            },
            "time": time.strftime("%Y-%m-%dT%H:%M"),
            "unique_id": event_id
          }
        }
      }
    end

    def post(url, data)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
  
      request = Net::HTTP::Post.new(url)
      request["accept"] = 'application/json'
      request["revision"] = '2023-10-15'
      request["content-type"] = 'application/json'
      request["Authorization"] = "Klaviyo-API-Key #{ENV['KLAVIYO_API_KEY']}"
  
      request.body = data.to_json
  
      response = http.request(request)
  
      Rails.logger.info("Klayvio response: #{response.body}")
  
      response.read_body
    end
  end
end