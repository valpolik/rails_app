class NotificationService
  EXTERNAL_SERVICE_URL = 'https://jsonplaceholder.typicode.com/posts'

  def self.call(event_type, data)
    payload = { event: event_type, data: data }.to_json

    begin
      RestClient.post(EXTERNAL_SERVICE_URL, payload, content_type: :json, accept: :json)
      Rails.logger.info("Notification sent: #{payload}")
    rescue RestClient::Exception => e
      Rails.logger.error("Failed to send notification: #{e.message}")
    rescue StandardError => e
      Rails.logger.error("Failed to send notification: #{e.message}")
    end
  end
end
