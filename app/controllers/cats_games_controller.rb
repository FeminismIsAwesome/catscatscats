class CatsGamesController < ApplicationController
  before_action :find_room
    skip_before_action :verify_authenticity_token
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

  def current_state
    player = CatPlayer.find_or_initialize_by(id: session[:player_id])
    render json: {
        player: player.as_json,
        players: @cat_game.cat_players.map(&:as_json),
        cardRepository: CatCard.hash_version
    }
  end

  def start_game
    CatGameResetter.new(@cat_game, current_player).start_game
    CatGamesChannel.broadcast_to @cat_game.id, {message: {food: 2}, kind: 'refresh_draft_state'}
    head :ok
  end

  def simulate_cat_round
    CatGameResetter.new(@cat_game, current_player).simulate_cat_round
    CatGamesChannel.broadcast_to @cat_game.id, {message: {empty: rand()}, kind: 'refresh_draft_state'}
    head :ok
  end

  def simulate_card_playing_round
    CatGameResetter.new(@cat_game, current_player).simulate_card_playing_round
    CatGamesChannel.broadcast_to @cat_game.id, {message: {empty: rand()}, kind: 'refresh_draft_state'}
    head :ok
  end

  def refresh_state
    player = CatPlayer.find_or_initialize_by(id: session[:player_id])
    render json: {
        player: player.as_json,
        players: @cat_game.cat_players.map(&:as_json),
        current_draft_hand: player.current_draft_hand,
        current_draft_index: player.current_draft_index,
        selected_cards: player.hand_card_ids,
        state: @cat_game.state,
        shelter_cats: @cat_game.shelter_cat_map,
        display_loading: player.display_loading?,
        current_bids: current_player.bids.map(&:as_json),
        current_turn_player: @cat_game.cat_players.find_by(id: @cat_game.current_player_id).as_json
    }
  end

  private

  def find_room
    @cat_game = CatGame.find_or_create_by(id: params[:id])
  end
end