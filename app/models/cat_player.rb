# == Schema Information
#
# Table name: cat_players
#
#  id                :bigint           not null, primary key
#  actions_provided  :jsonb
#  catnip            :integer          default(0)
#  energy_count      :integer          default(0)
#  energy_maximum    :integer          default(10)
#  food              :integer          default(0)
#  hand_card_ids     :jsonb
#  litterbox         :integer          default(0)
#  name              :string
#  owned_card_ids    :jsonb
#  toys              :integer          default(0)
#  upkeeps_performed :integer
#  victory_points    :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cat_game_id       :bigint
#  next_player_id    :bigint
#  remote_id         :string
#
# Indexes
#
#  index_cat_players_on_cat_game_id  (cat_game_id)
#
class CatPlayer < ApplicationRecord
  belongs_to :cat_game
  belongs_to :next_player, class_name: "CatPlayer", optional: true
  has_many :owned_cats

  def as_json
    (super).merge({owned_cards_count: owned_card_ids.count,
                  owned_cats: owned_cats.map(&:as_json)})
  end

  def add_card_to_hand(card)
    self.hand_card_ids += [card.id]
  end

  def current_draft_hand
    actions_provided[current_draft_index]
  end

  def bids
    ShelterCatBid.where(cat_player_id: self.id)
  end

  def current_draft_index
    hand_card_ids.count
  end

  def player_drafting?
    actions_provided.count < 7
  end

  def display_loading?
    cat_game.drafting? && current_draft_index >= actions_provided.count
  end

  def increment_category(category, num)
    current_value = self.attributes[category]
    new_value = [current_value + num, 0].max
    update!(category => new_value)
  end

  def adjust_energy(num)
    self.energy_count += num
    save!
  end

  def run_background_cards

  end
end
