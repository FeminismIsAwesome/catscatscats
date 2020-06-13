# == Schema Information
#
# Table name: cat_cards
#
#  id                :bigint           not null, primary key
#  description       :string
#  hover_description :text
#  kind              :string
#  number_tl         :string
#  number_tr         :string
#  self_hosted       :boolean
#  subtype           :string
#  tile_image        :text
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  virtual_id        :integer
#
require 'csv'

class CatCard < ApplicationRecord
  CATS_PATH = Rails.root.join('config', 'cats.csv')

  def self.hash_version
    hash = {}
    CatCard.find_each do |card|
      hash[card.id] = card.as_json
    end
    hash
  end

  def seed_cats
    CatCard.destroy_all
    CatDeck.destroy_all
    ShelterCat.destroy_all
    cat_index = 0
    @cats = CSV.read(CATS_PATH,headers: true).each do |cat|
      cat_card = CatCard.find_or_initialize_by(virtual_id: cat_index)
      cat_card.update!(
                 title: cat['title'],
          subtype: cat['subtype'],
          description: cat['description'],
          number_tl: cat['Number-tl'],
          number_tr:  cat['Number-tr'],
          kind: cat['type'],
          self_hosted: cat['SELF'].present?,
          tile_image: cat['tile_image'],
          hover_description: cat['hover_description']
      )
      cat_index += 1
    end
  end

  def play(player, game)
    player.update!(energy_count: player.energy_count - number_tl.to_i)
    if number_tr.present?
      parse_resource(player)
    end
  end

  def has_choice?
    player['choice_opponent'].present? || player['choice_self'].present? || player['choice_special'].present?
  end

  def choices

  end

  def play_response(player, game, choice)
    
  end

  def requires_choice?

  end

  private

  def parse_resource(player)
    unit_shifts = Hash.new(0)
    number_tr.chars.each do |letter|
      case letter
      when 'F'
        unit_shifts['food'] += 1
      when 'C'
        unit_shifts['catnip'] += 1
      when 'T'
        unit_shifts['toys'] += 1
      when 'L'
        unit_shifts['litterbox'] += 1
      when 'E'
        unit_shifts['energy_count'] += 1
      end
    end
    player.update!(
              food: player.food + unit_shifts['food'],
              catnip: player.catnip + unit_shifts['catnip'],
              toys: player.toys + unit_shifts['toys'],
              litterbox: player.litterbox + unit_shifts['litterbox'],
              energy_count: player.energy_count + unit_shifts['energy_count']
    )
  end
end
