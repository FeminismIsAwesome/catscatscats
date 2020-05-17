# == Schema Information
#
# Table name: cat_games
#
#  id         :bigint           not null, primary key
#  ended_at   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CatGame < ApplicationRecord
  has_one :cat_deck
  has_many :cat_players

  ACTION_DECK_TYPES = %w(action item)
  CAT_DECK_TYPES = %w(cat)
  EVENT_DECK_TYPES = %w(event)

  def generate_deck
    deck = CatDeck.first_or_initialize(cat_game: self)
    generated_card_ids = CatCard.where(kind: ACTION_DECK_TYPES).order("RANDOM()").pluck(:id)
    deck.update!(deck_pile: generated_card_ids)
  end
end
