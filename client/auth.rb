# frozen_string_literal: true

require './urls'

# module responsible for handlind auth related API business
module Auth
  include Urls

  def register(password_confirmation:)
    url = "#{API_URL}/sign_up"
    body = {
      user: {
        username: username,
        password: password,
        password_confirmation: password_confirmation
      }
    }
    self.class.post(url, body: body)
  end

  private

  def auth_header
    { Authorization: "Bearer #{jwt}" }
  end

  def jwt
    url = "#{API_URL}/sign_in"
    body = {
      session: {
        username: username,
        password: password
      }
    }
    self.class.post(url, body: body).parsed_response['jwt']
  end
end
