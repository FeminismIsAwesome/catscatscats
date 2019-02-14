require 'csv'

class CatsController < ApplicationController

  def index
    cats_path = Rails.root.join('config', 'cats.csv')
    @cats = CSV.read(cats_path,headers: true).sort{|cat| cat["type"] == 'cat' ? 0 : 1}
    @use_point_buy = false
  end

end
