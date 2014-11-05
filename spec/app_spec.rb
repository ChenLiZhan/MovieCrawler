require_relative 'spec_helper'
require_relative 'support/debut_helpers'
require 'json'

describe 'MovieCrawler debut' do

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
      last_response.must_be_instance_of String
    end

    it 'should return 404 for unknown category' do
      get "/api/v1/rank/#{rand(4..100)}.json"
      last_response.must_be :not_found?
    end
  end

  describe 'Getting the info_list' do
    it 'should return ok and json format' do
      get "api/v1/info/#{INFO_HELPER[rand(2)]}"
      last_response.must_be :ok?
      last_response.must_be_instance_of String
    end

    
end
