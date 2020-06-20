# == Schema Information
#
# Table name: cat_players
#
#  id               :bigint           not null, primary key
#  actions_provided :jsonb
#  catnip           :integer          default(0)
#  energy_count     :integer          default(0)
#  energy_maximum   :integer          default(10)
#  food             :integer          default(0)
#  hand_card_ids    :jsonb
#  litterbox        :integer          default(0)
#  name             :string
#  owned_card_ids   :jsonb
#  toys             :integer          default(0)
#  victory_points   :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  cat_game_id      :bigint
#  next_player_id   :bigint
#  remote_id        :string
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

  def current_draft_hand
    actions_provided[current_draft_index]
  end

  def bids
    ShelterCatBid.where(cat_player_id: self.id)
  end

  def current_draft_index
    hand_card_ids.count
  end

  def display_loading?
    !cat_game.drafting? && actions_provided.count <= hand_card_ids.count
  end

  def adjust_energy(num)
    self.energy_count += num
    save!
  end
end
