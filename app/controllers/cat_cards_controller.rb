class CatCardsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: CatCard.all.map(&:as_json)
  end

  def generate_hand

  end

  def generate_deck

  end
end