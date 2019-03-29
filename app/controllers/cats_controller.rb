require 'csv'

class CatsController < ApplicationController

  def index
    cats_path = Rails.root.join('config', 'cats.csv')
    @cats = CSV.read(cats_path,headers: true).sort do
      | cat |
      if cat["type"] == 'cat'
        1
      elsif cat['type'] == 'starter'
        0
      else
        2
      end
    end
    @use_point_buy = false
  end

end
