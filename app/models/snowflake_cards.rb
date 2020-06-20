class SnowflakeCards
  attr_reader :cat_card
  def initialize(cat_card)
    @cat_card = cat_card
  end

  SNOWFLAKES = {
    "Sketchy Food" => :sketchy_food,
    "Serious Cat-titude" => :serious_catitude,
    "Swap Meet" => :swap_meet,
    "Searching for Scraps" => :searching_for_scraps,


  }

  def snowflake
    @snowflake ||= SNOWFLAKES[cat_card.title]
  end

  def is_snowflake?
    snowflake.present?
  end

  def play_snowflake
    send(snowflake_card)
  end

  private

  def sketchy_food

  end
end