MovieCrawler Web Application
=============================

## Our Heroku web service
Take the [link](https://movie-crawler.herokuapp.com/) to use our service.

## Description
You can use our web application to checkout the informations of movies. For example, you can quickly take a look at the informations of latest, second-round movies. Furthermore, we also provide you to get the top 10 famous moives and DVD rank.

## API Usages
There are several APIs you can use

+ Top 10 information:

        https://movie-crawler.herokuapp.com/api/v1/rank/(category).json

  You have three choices to replace the ```(category)``` part.
  1. use ```1``` to get the top 10 famous movies in U.S. area.
  2. use ```2``` to get the top 10 famous movies in Taiwan area.
  3. use ```3``` to get the top 10 famous DVD.

  *Ex:*
  If I want to get the top ten movies in Taiwan, then I will access

          https://movie-crawler.herokuapp.com/api/v1/rank/2.json

+ One more thing with Top 10:

  If you are impatient to see the whole ranking list and want to see the real best movie amont the three lists. You could have a "post" request to access the data.

  with

      curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"top\":3}"  http://movie-crawler.herokuapp.com/api/v1/checktop

  Only one command, the api will return you with the top 3 most popular movie in the three list all at once. Sounds interesting? Have a try!

+ To get informaitons of the latest or second round movies:
  1. If you want to take a look at the latest movies. Please access

          https://movie-crawler.herokuapp.com/api/v1/info/latest.json

  2. If you wnat to look the informations of the second-round ones.

          https://movie-crawler.herokuapp.com/api/v1/info/seond_round.json
