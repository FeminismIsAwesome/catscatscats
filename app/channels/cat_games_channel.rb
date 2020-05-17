class CatGamesChannel < ApplicationCable::Channel
  def subscribed
    cat_game = CatGame.find(params[:id])
    stream_for cat_game.id
  end

  def unsubscribed
  end
end