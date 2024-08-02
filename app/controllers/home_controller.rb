class HomeController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    page = params[:page].to_i || 1
    @user = current_user
    @movies = ImdbService.new.get_popular_movies params[:page].to_i, 10
  end

  def public
  end
end
