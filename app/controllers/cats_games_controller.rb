class CatsGamesController < ApplicationController
  before_action :find_room
    # skip_before_action :verify_authenticity_token
  def show
    if @cat_game.cat_players.where(id: session[:player_id]).empty?
      redirect_to new_player_path(cat_game_id: params[:id])
      return
    end
    @cat_game = CatGame.find_or_create_by(id: params[:id])
  end

  def act
    CatGamesChannel.broadcast_to @cat_game.id, {message: {food: 2}, kind: 'stats'}
    head :ok
  end

  def start_game
    CatGamesChannel.broadcast_to @cat_game.id, {message: {food: 2}, kind: 'start_game'}
    head :ok
  end

  def current_state
    player = CatPlayer.find_or_initialize_by(id: session[:player_id])
    render json: {
        player: player.as_json,
        players: @cat_game.cat_players.map(&:as_json)
    }
  end

  private

  def find_room
    @cat_game = CatGame.find_or_create_by(id: params[:id])
  end
end