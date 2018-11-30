require 'csv'

class CatsController < ApplicationController

  def index
    cats_path = Rails.root.join('config', 'cats.csv')
    @cats = CSV.read(cats_path,headers: true)
    @use_point_buy = true
  end

end
