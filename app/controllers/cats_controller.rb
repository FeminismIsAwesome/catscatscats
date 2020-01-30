require 'csv'

class CatsController < ApplicationController

  def just_cards
    @cats = Cat.get_cats
  end

  def index
    @email = Email.new
    @cats = Cat.get_cats
    @use_point_buy = false
  end

end
