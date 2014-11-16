require 'sinatra/base'
require 'movie_crawler'
require 'json'
# require 'sinatra/namespace'
require 'haml'
require 'yaml'
require_relative 'model/movie'

# web version of MovieCrawlerApp(https://github.com/ChenLiZhan/SOA-Crawler)
class MovieCrawlerApp < Sinatra::Base
  set :views, Proc.new { File.join(root, "views") }
  # register Sinatra::Namespace

  helpers do
    RANK_LIST = { '1' => 'U.S.', '2' => 'Taiwan', '3' => 'DVD' }

    def get_movie_info(moviename)
      # begin
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
        'type' => 'rank_table',
        'category' => RANK_LIST[category],
        'rank' => []
      }

      # category = params[:category]
      ranks_after['rank'] = MovieCrawler.get_table(category)
      ranks_after
    end

    def get_infos(category)
      begin
        infos_after = {
          'type' => 'info_list',
          'category' => category,
          'info' => []
        }

        # category = params[:category]
        infos_after['info'] = MovieCrawler.movies_parser(category)
      rescue
        halt 400
      else
        infos_after
      end
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

  get '/movie/:name.json' do
    content_type :json, charset: 'utf-8'

    if Movie.find_by(moviename: params[:name])
      # return "find"+params[:name]
      redirect "/moviechecked/#{params[:name]}"
    else
      movie = Movie.new
      movie.moviename = params[:name]
      movie.movieinfo = get_movie_info(params[:name]).to_json
      movie.save
      movie.movieinfo
    end
  end


  get '/moviechecked/:moviename' do
    content_type :json, charset: 'utf-8'

    @movie = Movie.find_by(moviename: params[:moviename])
    return @movie.movieinfo

  end
  # # namespace '/api/v1' do



    get '/rank/:category.json' do
      content_type :json, charset: 'utf-8'
      get_ranks(params[:category]).to_json
    end

    get '/info/:category.json' do
      content_type :json, charset: 'utf-8'
      get_infos(params[:category]).to_json
    end

    post '/checktop' do
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
