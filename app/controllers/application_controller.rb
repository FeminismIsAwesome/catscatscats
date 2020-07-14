class ApplicationController < ActionController::Base

  def current_game
    @cat_game ||= CatPlayer.find(session[:player_id]).cat_game
  end

  def current_player_id
    session[:player_id]
  end

  def current_player
    @cat_player ||= CatPlayer.find(session[:player_id])
  end
end
