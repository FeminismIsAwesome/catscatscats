module ApplicationHelper

  def render_cat_line(line)
    line = line.gsub(':butthole:', image_tag(asset_path("tolerance.jpeg"), class: 'tolerance'))
    line = line.gsub(/[pP]issed/, image_tag(asset_path("pissedreplace.png"), class: 'tolerance angry'))
    line = line.gsub('VP', image_tag(asset_path("coolcat.png"), class: 'tolerance angry shorten'))
    line.gsub(/[iI]nfluence/, image_tag(asset_path("money"), class: 'fish'))
  end

  def get_happiness(line)
    num = line.to_i
    (1..num).map do |_|
      image_tag(asset_path("coolcat.png"), class: 'tolerance angry shorten')
    end.join("\n")
  end

  def get_happiness_top_right(line)
    num = line.to_i
    cat_setup = (1..num.abs).map do |_|
      image_tag(asset_path("coolcat.png"), class: 'modifier-cat angry shorten')
    end.join("\n")
    if num < 0
      cat_setup = "<i class='fas fa-minus'></i>" + cat_setup
    end
    if line && line.include?("/:attachment:")
      cat_setup += "<span class='modifier-slash'>  /  </span>" + image_tag(asset_path("hanginthere.png"), class: 'modifier-cat angry shorten')
    end
    if line && line.include?("/:cat:")
      cat_setup += "<span class='modifier-slash'>  /  </span>" + image_tag(asset_path("angry_meow.png"), class: 'modifier-cat angry shorten')
    end
    cat_setup
  end

  def get_happiness_big(line)
    num = line.to_i
    cat_class = 'score-big angry shorten'
    if num > 3
      cat_class = 'score-small angry shorten'
    end
    (1..num).map do |_|
      image_tag(asset_path("coolcat.png"), class: cat_class)
    end.join("\n")
  end

  def get_happiness_medium(line)
    num = line.to_i
    cat_class = 'score-medium angry shorten'
    if num > 3
      cat_class = 'score-small-icon angry shorten'
    end
    image = ""
    if num < 0
      num = num.abs
      image += "<i class='fas fa-minus'></i>"
    end
    image = image + (1..num).map do |_|
      image_tag(asset_path("coolcat.png"), class: cat_class)
    end.join("\n")
    if line && line.include?("/:attachment:")
      image += "<span class='modifier-slash'>  /  </span>" + image_tag(asset_path("hanginthere.png"), class: 'modifier-cat angry shorten')
    end
    if line && line.include?("/:cat:")
      image += "<span class='modifier-slash'>  /  </span>" + image_tag(asset_path("angry_meow.png"), class: 'modifier-cat angry shorten')
    end
    image
  end


  def get_happiness_small(line)
    num = line.to_i
    cat_class = 'score-small-icon angry shorten'
    if num > 3
      cat_class = 'score-small-icon angry shorten'
    end
    (1..num).map do |_|
      image_tag(asset_path("coolcat.png"), class: cat_class)
    end.join("\n")
  end

  def render_subtype(cat)
    subtype = cat['subtype']
    if subtype == 'brat'
      return "<text class='bratty'><i class='fas fa-heart-broken'></i>️ #{subtype} </text>"
    elsif subtype == 'curious'
      return "<text class='curious'><i class='fas fa-eye'></i>️ #{subtype} </text>"
    elsif subtype == 'cuddly'
      return "<text class='cuddly'><i class='fas fa-heart'></i>️ #{subtype} </text>"
    elsif subtype == 'furocious'
      return "<text class='furocious'><i class='fas fa-fist-raised'></i>️ #{subtype} </text>"
    elsif subtype == 'conspirator'
      return "<text class='conspirator'><i class='fas fa-cat'></i>️ #{subtype} </text>"
    end
    subtype
  end

  def get_cost(cost)
    cost = cost.gsub('W', image_tag(asset_path("money"), class: 'fish'))
    cost = cost.gsub('F', image_tag(asset_path("couch.png"), class: 'fish'))
    cost = cost.gsub('C', image_tag(asset_path("catnip.png"), class: 'fish'))
    cost.gsub('T', image_tag(asset_path("cattoy.png"), class: 'fish'))
  end

  def get_tile_image(cat)
    if cat["SELF"].present?
      image_url(cat["tile_image"])
    else
      cat["tile_image"]
    end
  end
end
