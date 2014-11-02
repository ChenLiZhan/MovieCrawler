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

+ To get informaitons of the latest or second round movies:       
  1. If you want to take a look at the latest movies. Please access

          https://movie-crawler.herokuapp.com/api/v1/info/latest.json    

  2. If you wnat to look the informations of the second-round ones.
 
          https://movie-crawler.herokuapp.com/api/v1/info/seond_round.json    

