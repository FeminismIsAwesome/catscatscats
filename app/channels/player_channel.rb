class PlayerChannel < ApplicationCable::Channel
  def subscribed
    player = CatPlayer.find_or_initialize_by(cat_game_id: params[:cat_game_id], id: params[:id])
    player.save!
    stream_for player.id
  end

  def unsubscribed
  end
end