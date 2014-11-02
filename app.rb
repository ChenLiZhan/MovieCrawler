require 'sinatra/base'
require 'movie_crawler'
require 'json'

# web version of MovieCrawlerApp(https://github.com/ChenLiZhan/SOA-Crawler)
class MovieCrawlerApp < Sinatra::Base
  RANK_LIST = { '1' => 'Latest', '2' => 'Second_round' }

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
  end

  get '/api/v1/rank/:category.json' do
    content_type :json
    get_ranks(params[:category]).to_json
  end

  get '/api/v1/info/:category.json' do
    content_type :json
    get_infos(params[:category]).to_json
  end
end
