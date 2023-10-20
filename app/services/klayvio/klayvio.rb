module Klayvio
  class Klayvio
    def initialize
    end

    def user_signup(email:, occurred_at:, event_id:)
      data = event_data(event_type: 'User Signup', email: email, time: occurred_at, event_id: event_id)
  
      url = URI("https://a.klaviyo.com/api/events/")
  
      post(url, data)
    end

    def education_experience_entered(email:, occurred_at:, event_id:)
      data = event_data(event_type: 'Education Experience Entered', email: email, time: occurred_at, event_id: event_id)

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

    def event_data(event_type:, email:, time:, event_id:)
      {
        "data": {
          "type": "event",
          "attributes": {
            "properties": {},
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
                  "email": email,
                  "properties": {}
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
  
      puts response
  
      response.read_body
    end
  end
end