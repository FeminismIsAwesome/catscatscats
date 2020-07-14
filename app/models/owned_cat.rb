# == Schema Information
#
# Table name: owned_cats
#
#  id              :bigint           not null, primary key
#  happiness_level :integer          default(3)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cat_card_id     :bigint
#  cat_player_id   :bigint
#
# Indexes
#
#  index_owned_cats_on_cat_card_id    (cat_card_id)
#  index_owned_cats_on_cat_player_id  (cat_player_id)
#
class OwnedCat < ApplicationRecord
  belongs_to :cat_card
  belongs_to :cat_player

  def shift(amount: 0)
    update!(happiness_level: [happiness_level + amount, 1].max)
  end

  def unhappy?
    happiness_level <= 1
  end

  def meet_needs
    shifts = derive_shifts(cat_card.number_tr)
    cat_player.update!(
        food: cat_player.food - shifts['food'],
        catnip: cat_player.catnip - shifts['catnip'],
        toys: cat_player.toys - shifts['toys'],
        litterbox: cat_player.litterbox - shifts['litterbox'],
        energy_count: cat_player.energy_count - shifts['energy_count']
    )
  end

  def meet_greeds
    shifts = derive_shifts(cat_card.number_tl)
    cat_player.update!(
        food: cat_player.food - shifts['food'],
        catnip: cat_player.catnip - shifts['catnip'],
        toys: cat_player.toys - shifts['toys'],
        litterbox: cat_player.litterbox - shifts['litterbox'],
        energy_count: cat_player.energy_count - shifts['energy_count']
    )
  end

  def decide(meeting_decisions)
    if meeting_decisions[:meet_greeds] && meeting_decisions[:meet_needs]
      meet_greeds
      meet_needs
      shift(amount: 1)
    elsif meeting_decisions[:meet_needs]
      meet_needs
    elsif meeting_decisions[:meet_greeds]
      meet_greeds
    else
      shift(amount: -2)
    end
    score_cat
  end

  def score_cat
    if happiness_level == 1
      modifier = -2
    elsif happiness_level == 2
      modifier = -1
    elsif happiness_level == 3
      modifier = 0
    elsif happiness_level == 4
      modifier = 1
    else
      modifier = 2
    end
    shift = modifier + get_vps
    cat_player.update!(victory_points: cat_player.victory_points + shift)
  end

  private

  def get_vps
    cat_card.description.scan("VP").length
  end

  def derive_shifts(number)
    unit_shifts = Hash.new(0)
    number.strip.chars.each do |letter|
      case letter
      when 'F'
        unit_shifts['food'] += 1
      when 'C'
        unit_shifts['catnip'] += 1
      when 'T'
        unit_shifts['toys'] += 1
      when 'L'
        unit_shifts['litterbox'] += 1
      when 'E'
        unit_shifts['energy_count'] += 1
      end
    end
    unit_shifts
  end

end
