require 'faraday'
require 'json'

class ImdbService
  def initialize
    @conn = Faraday.new(url: 'https://imdb188.p.rapidapi.com') do |f|
      f.headers['x-rapidapi-key'] = ENV['IMDB_API_KEY']
      f.headers['x-rapidapi-host'] = ENV['IMDB_API_HOST']
      f.headers['Content-Type'] = 'application/json'
    end
  end

  def get_popular_movies page, per_page
    body = fetch_movies
    offset = (page - 1) * per_page
    body['data']['list'] = body['data']['list'][offset, per_page]
    body['data']['list'].map do |movie|
      movie = movie['title']
      {
        title: movie['titleText']['text'],
        year: movie['releaseYear']["year"],
        rating: movie['ratingsSummary']['aggregateRating'],
        poster: movie['primaryImage']['imageUrl']
      }
    end
  end

  def fetch_movies
    response = Rails.cache.fetch('imdb_movies', expires_in: 1.hour) do
      @conn.post('/api/v1/getPopularMovies') do |req|
        req.body = {
          country: { anyPrimaryCountries: ['US'] },
          limit: 200,
          releaseDate: { releaseDateRange: { start: '2020-01-01', end: '2029-12-31' } },
          userRatings: { aggregateRatingRange: { min: 6, max: 10 }, ratingsCountRange: { min: 1000 } },
          genre: { allGenreIds: ['Action'] },
          runtime: { runtimeRangeMinutes: { min: 0, max: 120 } }
        }.to_json
      end
    end
    JSON.parse(response.body)
  end
end
