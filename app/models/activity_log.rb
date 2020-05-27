# == Schema Information
#
# Table name: activity_logs
#
#  id            :bigint           not null, primary key
#  description   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cat_game_id   :bigint
#  cat_player_id :bigint
#
# Indexes
#
#  index_activity_logs_on_cat_game_id    (cat_game_id)
#  index_activity_logs_on_cat_player_id  (cat_player_id)
#
class ActivityLog < ApplicationRecord

end
