class ShelterCatsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def bid
    bids = params.to_unsafe_h[:bids]
    bids.each do |bid|
      shelter_cat_bid = ShelterCatBid.find_or_initialize_by(cat_player_id: current_player_id,
      shelter_cat_id: bid[:shelter_cat_id])
      shelter_cat_bid.update!(bid_amount: bid[:bid_amount])
    end
    current_game.update!(bids_placed: current_game.bids_placed + [bids])
    current_game.cycle_player_order!
    if(current_game.bidding_phase_complete?)
      current_game.move_to_bidding_phase!
    end
    CatGamesChannel.broadcast_to @cat_game.id, {message: {empty: rand()}, kind: 'refresh_draft_state'}
    head :ok
  end

  def determine_payouts

  end
end