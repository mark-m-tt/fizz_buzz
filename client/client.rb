# frozen_string_literal: true

require 'httparty'
require 'dotenv'

class Client
  Dotenv.load('./.env')
  API_BASE_URL = ENV["APIBASEURL"]
  API_PREFIX = '/api/v1'
  FAVOURITES_PREFIX = '/favourites'
  API_URL = API_BASE_URL + API_PREFIX
  FAVOURITES_URL = API_URL + FAVOURITES_PREFIX

  include HTTParty

  def initialize(username:, password:)
    @username = username
    @password = password
  end

  def register(password_confirmation:)
    url = "#{API_URL}/sign-up"
    body = {
      user: {
        username: username,
        password: password,
        password_confirmation: password_confirmation
      }
    }
    self.class.post(url, body: body)
  end

  # private

  attr_reader :username, :password

  def auth_header
    "Bearer #{jwt}"
  end

  def jwt
    url = "#{API_URL}/sign-in"
    body = {
      session: {
        username: username,
        password: password
      }
    }
    self.class.post(url, body: body).parsed_response["jwt"]
  end
end