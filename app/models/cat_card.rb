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
    @cats = CSV.read(CATS_PATH,headers: true).each do |cat|
      CatCard.create!(
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
    end
  end
end
