require 'csv'

class CatCard < ApplicationRecord
  CATS_PATH = Rails.root.join('config', 'cats.csv')

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
          tile_image: cat['tile_image']
      )
    end
  end
end