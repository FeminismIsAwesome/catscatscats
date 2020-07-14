class PlayersController < ApplicationController
  def new
  end

  def whoami

  end

  def create
    name = params[:cat_player][:name]
    cat_player = CatPlayer.find_or_initialize_by(name: name, cat_game_id: params[:cat_game_id])
    cat_player.save!
    if cat_player.created_at > 10.minutes.ago
      players = cat_player.cat_game.cat_players
      CatGamesChannel.broadcast_to cat_player.cat_game_id, {message: players.map(&:as_json) , kind: 'new_subscription'}
    end
    session[:player_id] = cat_player.id
    redirect_to cats_game_path(params[:cat_game_id])
  end

  def feed_cats
    decisions = params[:feeding_decisions].to_unsafe_h
    decisions.each do |decision|
      owned_cat = current_player.owned_cats.find(decision[:owned_cat_id])
      owned_cat.decide(decision)
    end
    current_player.run_background_cards
    current_game.check_if_everyone_upkeeped!
    CatGamesChannel.broadcast_to current_game.id, {message: {empty: rand()}, kind: 'refresh_draft_state'}
    head :ok
  end
end