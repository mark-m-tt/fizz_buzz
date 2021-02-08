# frozen_string_literal: true

module Urls
  API_BASE_URL = ENV['APIBASEURL']
  API_PREFIX = '/api/v1'
  FAVOURITES_PREFIX = '/favourites'
  API_URL = API_BASE_URL + API_PREFIX
  FAVOURITES_URL = API_URL + FAVOURITES_PREFIX
end
