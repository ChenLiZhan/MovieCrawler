require 'sinatra/base'
require 'movie_crawler'
require 'json'
# require 'sinatra/namespace'
require 'haml'
require 'yaml'
require_relative 'model/movie'
require_relative 'model/theater'

# web version of MovieCrawlerApp(https://github.com/ChenLiZhan/SOA-Crawler)
class MovieCrawlerApp < Sinatra::Base
  set :views, Proc.new { File.join(root, "views") }
  # register Sinatra::Namespace

  helpers do
    # RANK_LIST = { '1' => 'U.S.', '2' => 'Taiwan', '3' => 'DVD' }

    def get_movie_info(moviename)
      # begin
        # halt 404 if moviename == nil?
        movie_crawled={
          'type' => 'movie_info',
          'info' => []
        }

        # moviename = params[:moviename]
        movie_crawled['info'] = MovieCrawler.get_movie_info(moviename)
        movie_crawled
    end

    def get_ranks(category)
      halt 404 if category.to_i > 3
      ranks_after = {
        'content_type' => 'rank_table',
        'category' => category,
        'content' => []
      }

      # category = params[:category]
      ranks_after['content'] = MovieCrawler.get_table(category)
      ranks_after
    end

    def get_infos(category)
      halt 404 if category == nil?
      infos_after = {
        'content_type' => 'info_list',
        'category' => category,
        'content' => []
      }

      # category = params[:category]
      infos_after['content'] = MovieCrawler.movies_parser(category)
      infos_after
    end

    def topsum(n)
      us1 = YAML.load(MovieCrawler::us_weekend).reduce(&:merge)
      tp1 = YAML.load(MovieCrawler::taipei_weekend).reduce(&:merge)
      dvd1 = YAML.load(MovieCrawler::dvd_rank).reduce(&:merge)
      keys = [us1, tp1, dvd1].flat_map(&:keys).uniq
      keys = keys[0, n]

      keys.map! do |k|
        { k => [{us:us1[k] || "0" }, { tp:tp1[k] || "0" }, { dvd:dvd1[k] || "0"}] }
      end
    end
  end

  get '/' do
    haml :home
  end

  # # namespace '/api/v1' do

  get '/api/v2/movie/:name.json' do
    content_type :json, charset: 'utf-8'

    if Movie.find_by(moviename: params[:name])
      # return "find"+params[:name]
      redirect "/api/v2/moviechecked/#{params[:name]}"
    else
      movie = Movie.new
      movie.moviename = params[:name]
      movie.movieinfo = get_movie_info(params[:name]).to_json
      movie.save
      movie.movieinfo
    end
  end

  get '/api/v2/moviechecked/:moviename' do
    content_type :json, charset: 'utf-8'

    @movie = Movie.find_by(moviename: params[:moviename])
    return @movie.movieinfo
  end

  get '/api/v2/:type/:category.json' do
    content_type :json, charset: 'utf-8'

    if @data = Theater.find_by(category: params[:category])
      @data = {
        'content_type' => @data.content_type,
        'category' => @data.category,
        'info' => JSON.parse(@data.content)
      }
      @data.to_json
    else
      data = params[:type] == 'info' ? get_infos(params[:category]) : \
      get_ranks(params[:category])
      theater = Theater.new
      theater.content_type = data['content_type']
      theater.category = data['category']
      theater.content = data['content'].to_json
      theater.save && data.to_json
    end
  end

  post '/api/v2/checktop' do
    content_type :json, charset: 'utf-8'
    req = JSON.parse(request.body.read)
    n = req['top']
    halt 400 unless req.any?
    halt 404 unless [*1..10].include? n
    topsum(n).to_json
  end

  get '/info/' do
    halt 400
  end
  # end
end
