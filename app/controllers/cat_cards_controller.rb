class CatCardsController < ApplicationController
  def index
    render json: CatCard.all.map(&:as_json)
  end

  def act
    ActionCable.server.broadcast 'conversations_channel', {message: {treats: 2}, kind: 'stats'}
    head :ok
  end
end