class FetchImdbDataJob < ApplicationJob
  queue_as :default

  def perform
    imdb_service = ImdbService.new

    popular_movies = imdb_service.fetch_movies

    Rails.cache.write('imdb_movies', popular_movies, expires_in: 1.hour)
  end
end
