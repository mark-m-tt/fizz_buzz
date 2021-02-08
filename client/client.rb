# frozen_string_literal: true

require 'httparty'
require 'dotenv'
require './auth'
require './urls'

# The main heart of the client app
class Client
  Dotenv.load('./.env')
  include HTTParty
  include Urls
  include Auth

  def initialize(username:, password:)
    @username = username
    @password = password
  end

  def play(starting_number: 1, count: 15)
    url = "#{API_URL}/play?starting_number=#{starting_number}&count=#{count}"
    self.class.get(url).parsed_response
  end

  def list_favourites
    self.class.get(FAVOURITES_URL, headers: auth_header).parsed_response
  end

  def make_favourite(number:)
    self.class.post(FAVOURITES_URL, body: { number: number }, headers: auth_header).parsed_response
  end

  def remove_favourite(number:)
    id = get_favourite_id_from_number(number: number)
    self.class.delete("#{FAVOURITES_URL}/#{id}", headers: auth_header).parsed_response
  end

  private

  attr_reader :username, :password

  def get_favourite_id_from_number(number:)
    url = "#{FAVOURITES_URL}/find_by_number/#{number}"
    self.class.get(url, headers: auth_header).parsed_response.dig('favourite', 'id')
  end
end
