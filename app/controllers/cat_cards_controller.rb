class CatCardsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: CatCard.all.map(&:as_json)
  end

  def pick
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

  def burn
    current_game.cycle_player_order_ignore_passes!
    other_cards = cat_player.hand_card_ids.reject{|id| selected_card.id == id}
    cat_player.update!(hand_card_ids: other_cards, energy_count: cat_player.energy_count + 1)
    current_game.update!(cards_played: current_game.cards_played + ["burn-#{selected_card.id}"])
    CatGamesChannel.broadcast_to cat_player.cat_game_id, {message: {other: rand()}, kind: 'refresh_draft_state'}
    head :ok
  end

  def play_choice

  end

  def play
    cat_player.cat_game.cycle_player_order_ignore_passes!
    other_cards = cat_player.hand_card_ids.reject{|id| selected_card.id == id}
    if !selected_card.has_enough_energy?(cat_player)
      render json: {error: 'not enough energy. require more catlateral'}
    elsif selected_card.requires_choice?
      render json: selected_card.choices.as_json
    else
      selected_card.play(cat_player, current_game)
      cat_player.update!(hand_card_ids: other_cards)
      current_game.update!(cards_played: current_game.cards_played + [selected_card.id])
      CatGamesChannel.broadcast_to cat_player.cat_game_id, {message: {new: rand()}, kind: 'refresh_draft_state'}
      render json: {status: 'done'}
    end
  end

  def pass
    players_passed_update = (cat_player.cat_game.players_passed + [cat_player.id]).uniq
    cat_player.cat_game.update!(players_passed: players_passed_update)
    cat_player.cat_game.check_move_to_cat_feeding!
    CatGamesChannel.broadcast_to cat_player.cat_game_id, {message: {tet2: rand()}, kind: 'refresh_draft_state'}
    head :ok
  end

  private

  def cat_player
    @cat_player ||= CatPlayer.find_by!(id: session[:player_id])
  end
  def selected_card
    @card ||= CatCard.find_by!(id: params[:id])
  end
end