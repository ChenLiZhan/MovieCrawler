require 'sinatra/base'
require 'movie_crawler'
require 'json'

# web version of MovieCrawlerApp(https://github.com/ChenLiZhan/SOA-Crawler)
class MovieCrawlerApp < Sinatra::Base
  RANK_LIST = { '1' => 'U.S.', '2' => 'Taiwan', '3' => 'DVD' }

  helpers do
    def get_ranks(category)
      ranks_after = {
        'type' => 'rank_table',
        'category' => RANK_LIST[category],
        'rank' => []
      }

      category = params[:category]
      ranks_after['rank'] = MovieCrawler.get_table(category)
      ranks_after
    end

    def get_infos(category)
      infos_after = {
        'type' => 'info_list',
        'category' => category,
        'info' => []
      }

      category = params[:category]
      infos_after['info'] = MovieCrawler.movies_parser(category)
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

  get '/api/v1/rank/:category.json' do
    content_type :json
    get_ranks(params[:category]).to_json
  end

  get '/api/v1/info/:category.json' do
    content_type :json
    get_infos(params[:category]).to_json
  end

  post '/api/v1/checktop' do
    content_type :json
    req = JSON.parse(request.body.read)
    n = req['top']
    topsum(n).to_json
  end
end
