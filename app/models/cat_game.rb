# == Schema Information
#
# Table name: cat_games
#
#  id                :bigint           not null, primary key
#  bids_placed       :jsonb
#  cards_played      :jsonb
#  ended_at          :string
#  players_passed    :jsonb
#  state             :string           default("drafting")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  current_player_id :bigint
#
class CatGame < ApplicationRecord
  has_one :cat_deck, dependent: :destroy
  has_many :cat_players
  has_many :shelter_cats

  ACTION_DECK_TYPES = %w(action item)
  CAT_DECK_TYPES = %w(cat)
  EVENT_DECK_TYPES = %w(event)

  def generate_deck
    deck = CatDeck.first_or_initialize(cat_game_id: self.id)

    generated_card_ids = CatCard.where(kind: ACTION_DECK_TYPES).where.not(virtual_id: ignore_pulling_these_cards_for_now_virtual_ids).order("RANDOM()").pluck(:id)
    generated_cat_card_ids = CatCard.where(kind: CAT_DECK_TYPES).order("RANDOM()").pluck(:id)
    deck.save!
    deck.update!(deck_pile: generated_card_ids, cats_draw_pile: generated_cat_card_ids)
  end

  def check_move_to_cat_picking!
    if cat_players.count == cat_players.select{|cp| cp.hand_card_ids.count == 7}.count
      update!(state: 'cat_bidding',bids_placed: [])
      next_cats_phase
    end
  end

  def check_move_to_upkeep!
    if cat_players.count == players_passed.count
      update!(state: 'cat_upkeep')
    end
  end

  def check_if_everyone_upkeeped!
    if cat_players.map(&:upkeeps_performed).count == 1
        start_drafting_phase(random_players)
        update!(state: 'drafting')
    end
  end

  def move_to_card_playing!
    update!(state: 'card_playing')
  end

  def check_move_to_cat_feeding!
    if cat_players.count == players_passed.count
      move_to_cat_feeding!
    end
  end

  def move_to_cat_feeding!
    update!(state: 'cat_feeding')
  end

  def shelter_cat_map
    shelter_map = {}
    shelter_cats.each do |cat|
      shelter_map[cat.id] = {
          cat_card_id: cat.cat_card_id,
          cat_bids: cat.shelter_cat_bids.map(&:as_json),
      }
    end
    shelter_map
  end

  def output_kitties
    cats_to_put_out = cat_players.count + 1
    next_cat_cards = cat_deck.return_next_cat_cards(cats_to_put_out)

    next_cat_cards.each do |cat|
      ShelterCat.create!(cat_game: self, cat_card: cat)
    end
  end

  def next_cats_phase
    cat_deck.update!(cat_player_order: cat_players.order("random()").map(&:id))
  end

  def start_player_order(suggested_order=cat_deck.cat_player_order.first)
    update!(current_player_id: suggested_order)
  end

  def start_drafting_phase(random_players)
    random_players.each_with_index do |player, index|
      cards = cat_deck.return_next_action_cards(7)
      player.update!(energy_count: 10, catnip:0,
                     food:0,
                     litterbox:0,
                     toys: 0,
                     hand_card_ids: [], actions_provided: [cards.map(&:id)], owned_card_ids: [], next_player_id: random_players[(index + 1)% random_players.size].id)
    end
  end

  def cycle_player_order_ignore_passes!
    cat_player_order_adjusted = cat_deck.cat_player_order - players_passed
    current_index = cat_player_order_adjusted.find_index{|player_id| player_id == current_player_id }
    next_player = cat_player_order_adjusted[(current_index + 1) % cat_player_order_adjusted.count]
    update!(current_player_id: next_player)
  end

  def cycle_player_order!
    current_index = cat_deck.cat_player_order.find_index{|player_id| player_id == current_player_id }
    next_player = cat_deck.cat_player_order[(current_index + 1) % cat_deck.cat_player_order.count]
    update!(current_player_id: next_player)
  end

  def bidding_phase_complete?
    bids_placed.count > cat_players.count && bids_placed.last(cat_players.count).select(&:empty?).count == cat_players.count # all passes
  end

  def move_to_bidding_phase!
    update!(state: 'card_playing')
    shelter_cats.each do |shelter_cat|
      highest_bid = shelter_cat.biggest_player_bid
      if(highest_bid.present?)
        highest_bid.cat_player.adjust_energy( -highest_bid.bid_amount)
        OwnedCat.create!(cat_player: highest_bid.cat_player, cat_card: shelter_cat.cat_card)
        shelter_cat.destroy!
      end
    end
  end

  def drafting?
    state == 'drafting'
  end

  private

  def random_players
    cat_players.order("random()")
  end

  def ignore_pulling_these_cards_for_now_virtual_ids
    [95,96,97,98,125,126]
  end
end
