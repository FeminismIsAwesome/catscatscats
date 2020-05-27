# == Schema Information
#
# Table name: cat_decks
#
#  id                :bigint           not null, primary key
#  cat_player_order  :jsonb
#  cats_discard_pile :jsonb
#  cats_draw_pile    :jsonb
#  deck_pile         :jsonb
#  discard_pile      :jsonb
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cat_game_id       :bigint
#
# Indexes
#
#  index_cat_decks_on_cat_game_id  (cat_game_id)
#
class CatDeck < ApplicationRecord
  belongs_to :cat_game

  def return_next_action_cards(n)
    next_action_cards = deck_pile.shift(n)
    save!
    CatCard.where(id: next_action_cards)
  end

  def return_next_cat_cards(n)
    next_cards = cats_draw_pile.shift(n)
    save!
    CatCard.where(id: next_cards)
  end
end
