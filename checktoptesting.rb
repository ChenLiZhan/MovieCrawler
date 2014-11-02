require 'movie_crawler'
require 'json'
# n refers to the top n movies in three rank list, the method will return the result of three rank in one list accordingly
def topsum(n)
  us1 = YAML.load(MovieCrawler::us_weekend).reduce(&:merge)
  tp1 = YAML.load(MovieCrawler::taipei_weekend).reduce(&:merge)
  dvd1 = YAML.load(MovieCrawler::dvd_rank).reduce(&:merge)
  keys = [us1,tp1,dvd1].flat_map(&:keys).uniq
  keys = keys[0,n]

  keys.map do |k|
    {k => [{us:us1[k] || "0"},{tp:tp1[k] || "0"},{dvd:dvd1[k] || "0"}]}
  end
end

puts topsum(2).to_json

posts '/api/v1/checktop' do
  content_type :json
  req = JSON.parse(request.body.read)
  n = req['top']
  topsum(n).to_json
end
