require 'sinatra'
require 'sinatra/activerecord'
require_relative '../environments'

class Movie < ActiveRecord::Base
end

class Theater < ActiveRecord::Base
end
