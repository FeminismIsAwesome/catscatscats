class CatCardsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: CatCard.all.map(&:as_json)
  end

  def pick
    cat_player = CatPlayer.find_by!(id: session[:player_id])
    selected_card = CatCard.find_by!(id: params[:id])
    card_number = params[:card_number].to_i
    rest_of_cards = cat_player.actions_provided[card_number].select{|card| card.to_i != selected_card.id}
    cat_player.hand_card_ids << selected_card.id
    cat_player.save!
    next_player = cat_player.next_player
    next_player.actions_provided << rest_of_cards
    next_player.save!

    cat_player.cat_game.check_move_to_cat_picking!

    CatGamesChannel.broadcast_to cat_player.cat_game_id, {message: {empty: rand()}, kind: 'refresh_draft_state'}
    head :ok
  end

  def generate_hand

  end

  def generate_deck

  end
end