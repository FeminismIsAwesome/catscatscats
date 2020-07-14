class CatGameResetter
  attr_reader :cat_game, :current_player

  def initialize(cat_game, current_player)
    @cat_game = cat_game
    @current_player = current_player
  end

  def wipe_board
    OwnedCat.delete_all
    @cat_game.shelter_cats.destroy_all

  end

  def start_game
    wipe_board
    @cat_game.generate_deck
    random_players.each_with_index do |player, index|
      cards = @cat_game.cat_deck.return_next_action_cards(7)
      player.update!(energy_count: 10, catnip:0,
      food:0,
      litterbox:0,
      toys: 0,
     hand_card_ids: [], actions_provided: [cards.map(&:id)], owned_card_ids: [], next_player_id: random_players[(index + 1)% random_players.size].id)
    end
    @cat_game.update!(state: 'drafting')
  end

  def simulate_cat_round
    start_game
    random_players.each do |player|
      player.update!(hand_card_ids: player.actions_provided.first, actions_provided: [])
    end
    @cat_game.update!(state: 'cat_bidding')
    @cat_game.update!(bids_placed: [])
    @cat_game.next_cats_phase
    @cat_game.start_player_order(current_player.id)
  end

  def simulate_card_playing_round
    simulate_cat_round
    @cat_game.move_to_card_playing!
    @cat_game.shelter_cats.reload.each_with_index do |shelter_cat, i|
      player_to_go_to = random_players[i % random_players.count]
      OwnedCat.create!(cat_player: player_to_go_to, cat_card: shelter_cat.cat_card)
      shelter_cat.destroy!
    end
  end

  private

  def random_players
    @random_players ||= @cat_game.cat_players.order("random()")
  end
end