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

  def start_game
    @cat_game.generate_deck
    cat_players = @cat_game.cat_players.order("random()")
    cat_players.each_with_index do |player, index|
      cards = @cat_game.cat_deck.return_next_action_cards(7)
      player.update!(energy_count: 10, hand_card_ids: [], actions_provided: [cards.map(&:id)], owned_card_ids: [], next_player_id: cat_players[(index + 1)% cat_players.size].id)
    end
    CatGamesChannel.broadcast_to @cat_game.id, {message: {food: 2}, kind: 'refresh_draft_state'}
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

  def simulate_cat_round
    @cat_game.generate_deck
    cat_players = @cat_game.cat_players.order("random()")
    cat_players.each_with_index do |player, index|
      cards = @cat_game.cat_deck.return_next_action_cards(7)
      player.update!(energy_count: 10, hand_card_ids: cards.map(&:id), actions_provided: [cards.map(&:id)], owned_card_ids: [], next_player_id: cat_players[(index + 1)% cat_players.size].id)
    end
    @cat_game.update!(state: 'cat_bidding')
    @cat_game.update!(bids_placed: [])
    @cat_game.shelter_cats.destroy_all
    @cat_game.next_cats_phase
    @cat_game.start_player_order(current_player_id)
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