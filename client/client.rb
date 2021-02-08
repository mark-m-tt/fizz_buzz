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

  def play(starting_number: 1, count: 15)
    url = "#{API_URL}/play?starting_number=#{starting_number}&count=#{count}"
    self.class.get(url).parsed_response
  end

  def list_favourites
    self.class.get(FAVOURITES_URL, headers: auth_header).parsed_response
  end

  def make_favourite(number:)
    self.class.post(FAVOURITES_URL, body: { number: number}, headers: auth_header).parsed_response
  end

  def remove_favourite(number:)
    id = get_favourite_id_from_number(number: number)
    self.class.delete("#{FAVOURITES_URL}/#{id}", body: { number: number}, headers: auth_header).parsed_response
  end

  # private

  attr_reader :username, :password

  def auth_header
    { "Authorization": "Bearer #{jwt}" }
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

  def get_favourite_id_from_number(number:)
    url = "#{FAVOURITES_URL}/find_by_number/#{number}"
    self.class.get(url, headers: auth_header).parsed_response.dig("favourite", "id")
  end
end