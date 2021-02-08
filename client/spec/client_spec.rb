# frozen_string_literal: true

require_relative '../client'
require_relative '../urls'
require 'pry'
Dotenv.load('../../.env')
DummyResponse = Struct.new(:parsed_response)

RSpec.describe Client do
  describe '#play' do
    it 'submits a get request to the appropriate URL' do
      url = 'play?starting_number=1&count=15'
      expect_class_to_receive(:get, with: api_url(url))
      client.play
    end
  end

  describe '#list_favourites' do
    it 'tries to log in and submits a get request to the appropriate URL' do
      expect_login_attempt
      expect_class_to_receive(:get, with: [api_url('favourites'), auth_header])
      client.list_favourites
    end
  end

  describe '#make_favourite' do
    it 'tries to log in and submits a post request to the appropriate URL' do
      expect_login_attempt
      favourite_hash = { body: { number: 1 } }
      expect_class_to_receive(:post, with: [api_url('favourites'), favourite_hash.merge(auth_header)])
      client.make_favourite(number: 1)
    end
  end

  describe '#remove_favourite' do
    it 'tries to log in, find the record and submits a delete request to the appropriate URL' do
      # Find the favourite by number
      expect_login_attempt
      expect(described_class)
        .to receive(:get)
        .with(api_url('favourites/find_by_number/1'), auth_header)
        .and_return(dummy_response({ 'favourite' => { 'id' => 1 } }))

      # Then delete it by ID
      expect_login_attempt
      expect_class_to_receive(:delete, with: [api_url('favourites/1'), auth_header])
      client.remove_favourite(number: 1)
    end
  end

  describe '#registration' do
    it 'submits a post requeste to the appropriate URL' do
      body = {
        body: {
          user: {
            username: 'username',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      }
      expect_class_to_receive(:post, with: [api_url('sign_up'), body])
      client.register(password_confirmation: 'password')
    end
  end

  def client(username: 'username', password: 'password')
    Client.new(username: username, password: password)
  end

  def expect_class_to_receive(method, with:)
    expect(described_class).to receive(method).with(*with).and_return dummy_response
  end

  def expect_login_attempt
    sign_in_url = 'sign_in'
    sign_in_hash = { body: { session: { username: 'username', password: 'password' } } }
    expect(described_class)
      .to receive(:post)
      .with(api_url(sign_in_url), sign_in_hash)
      .and_return(DummyResponse.new({ 'jwt' => 'token' }))
  end

  def api_url(string)
    "http://phoenix:4000/api/v1/#{string}"
  end

  def auth_header
    { headers: { Authorization: 'Bearer token' } }
  end

  def dummy_response(contents = '')
    DummyResponse.new(contents)
  end
end
