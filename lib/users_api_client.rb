require 'rest-client'
require 'json'

class UsersApiClient
  def initialize(base_url, token = nil)
    @base_url = base_url
    @token = token
  end

  def set_token(token)
    @token = token
  end

  def list
    response = RestClient.get("#{@base_url}/users", auth_header)
    JSON.parse(response.body)
  end

  def create(email:, password:, password_confirmation:)
    payload = { user: { email: email, password: password, password_confirmation: password_confirmation } }
    response = RestClient.post("#{@base_url}/users", payload.to_json, json_headers)
    data = JSON.parse(response.body)
    @token = data['token'] if data['token']
    data
  end

  def get(id)
    response = RestClient.get("#{@base_url}/users/#{id}", auth_header)
    JSON.parse(response.body)
  end

  def update(id, **attrs)
    payload = { user: attrs.slice(:email, :password, :password_confirmation) }
    response = RestClient.patch("#{@base_url}/users/#{id}", payload.to_json, auth_header.merge(content_type: :json))
    JSON.parse(response.body)
  end

  def delete(id)
    RestClient.delete("#{@base_url}/users/#{id}", auth_header)
    true
  end

  def login(email:, password:)
    payload = { user: { email: email, password: password } }
    response = RestClient.post("#{@base_url}/users/login", payload.to_json, json_headers)
    data = JSON.parse(response.body)
    @token = data['token'] if data['token']
    data
  end

  private

  def auth_header
    @token ? { 'Authorization' => "Bearer #{@token}" } : {}
  end

  def json_headers
    { content_type: :json }
  end
end
