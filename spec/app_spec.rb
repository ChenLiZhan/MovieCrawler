require_relative 'spec_helper'
require_relative 'support/debut_helpers'
require 'json'

describe 'MovieCrawler debut' do

  include DebutHelpers

  describe 'Getting the root of MovieCrawler' do
    it 'should return ok' do
      get '/'
      last_response.must_be :ok?
    end
  end

  describe 'Getting the rank_table' do
    it 'should return ok and json format' do
      get "/api/v1/rank/#{rand(1..3)}.json"
      last_response.must_be :ok?
      # last_response.must_be_instance_of String
    end

    it 'should return 404 for unknown category' do
      get "/api/v1/rank/#{rand(4..100)}.json"
      last_response.must_be :not_found?
    end
  end

  describe 'Getting the info_list' do
    it 'should return ok and json format' do
      get "/api/v1/info/#{info_helper.sample}.json"
      last_response.must_be :ok?
      # last_response.must_be_instance_of String
    end

    it 'should return bad request if not specify category' do
      get '/api/v1/info/'
      last_response.must_be :bad_request?
    end
  end

  describe 'Checking the top n among three rank' do
    it 'should return ok and json format' do
      header = { 'Content-type' => 'application/json' }
      body = { top: 3 }

      post '/api/v1/checktop', body.to_json, header
      last_response.must_be :ok?
      last_response.must_be_instance_of Rack::MockResponse
    end

    it 'should return 404 for n other than 1..10' do
      header = { 'Content-type' => 'application/json' }
      body = { top: rand(11..100) }

      post '/api/v1/checktop', body.to_json, header
      last_response.must_be :not_found?
    end

    it 'should return 400 for bad JSON format' do
      header = { 'Content-type' => 'application/json' }
      body = {}

      post '/api/v1/checktop', body.to_json, header
      last_response.must_be :bad_request?
    end
  end
end
