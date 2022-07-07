module ApplicationHelper

  def derive_background_image(cat)
    if cat['type'] == 'cat'
      # brat
      # curious
      # cuddly
      # furocious
      image = if cat['subtype'] == 'brat'
                "curious-bg-1.PNG"
              elsif cat['subtype'] == 'curious'
                "curious-bg-2.PNG"
              elsif cat['subtype'] == 'cuddly'
                "cuddly-bg.PNG"
              elsif cat['subtype'] == 'furocious'
                "furocious-back.PNG"
              end
      "background-image:url(\"#{image_url(image)}\"); background-size: cover;"
    elsif cat['type'] == 'action'
      image = "action_bg.jpg"
      "background-image:url(\"#{image_url(image)}\"); background-size: cover;"
    else
      ""
    end
  end

  def render_cat_line(line, big_cat: false)
    line = line.gsub(':butthole:', image_tag(asset_path("tolerance.jpeg"), class: 'tolerance'))
    line = line.gsub(/[pP]issed/, image_tag(asset_path("pissedreplace.png"), class: 'tolerance angry'))
    if big_cat
      line = line.gsub('VP', image_tag(asset_path("greedv2.PNG"), class: 'big-icon angry shorten'))
    else
      line = line.gsub('VP', image_tag(asset_path("greedv2.PNG"), class: 'tolerance angry shorten'))
    end
    line = line.gsub(':trophy:', "<i class='fa fa-trophy'></i>")
    line = line.gsub('litterbox', image_tag(asset_path('litterbox.png'), class: 'tolerance angry shorten'))
    line = line.gsub('catnip', image_tag(asset_path('catnip.png'), class: 'tolerance angry shorten'))
    line = line.gsub('toy', image_tag(asset_path('toy.PNG'), class: 'tolerance angry shorten'))
    line.gsub('food', image_tag(asset_path('food.PNG'), class: 'tolerance angry shorten'))
    # line.gsub(/[iI]nfluence/, image_tag(asset_path("money")), class: 'tolerance angry shorten')
  end

  def get_costs(letters)
    return nil if letters.nil?
    if letters == "0"
      return nil
    end
    letters.chars.map do |letter|
      if letter == 'F'
        image_tag(asset_path('food.PNG'), class: 'tolerance angry shorten')
      elsif letter == 'T'
        image_tag(asset_path('toy.PNG'), class: 'tolerance angry shorten')
      elsif letter == 'C'
        image_tag(asset_path('catnip.png'), class: 'tolerance angry shorten')
      elsif letter == 'L'
        image_tag(asset_path('litterbox.PNG'), class: 'tolerance angry shorten')
      elsif letter == 'E'
        "<i class='fa fa-lightbulb'/>"
      elsif letter == 'M'
        'CARD'
      end
    end.compact.join("<span> </span>")
  end

  def get_needs(letters, no_span=false)
    letter_data = letters.chars.map do |letter|
      if letter == 'F'
        image_tag(asset_path('food.PNG'), class: 'tolerance angry shorten')
      elsif letter == 'T'
        image_tag(asset_path('toy.PNG'), class: 'tolerance angry shorten')
      elsif letter == 'C'
        image_tag(asset_path('catnip.png'), class: 'tolerance angry shorten')
      elsif letter == 'L'
        image_tag(asset_path('litterbox.png'), class: 'tolerance angry shorten')
      end
    end.compact
    if no_span
      letter_data.join("")
    else
      letter_data.join("<span style='margin-left: 5px;'> </span>")
    end
  end

  def get_happiness(line)
    num = line.to_i
    (1..num).map do |_|
      image_tag(asset_path("coolcat.png"), class: 'tolerance angry shorten')
    end.join("\n")
  end

  def get_happiness_top_right(line, cat_subtype)
    num = line.to_i
    image_asset = "coolcat.png"
    if num < 0
      image_asset = "negative-face.png"
    end
    cat_setup = (1..num.abs).map do |_|
      image_tag(asset_path(image_asset), class: 'modifier-cat angry shorten')
    end.join("\n")
    if cat_subtype.present?
      cat_setup += render_subtype(cat_subtype, false)
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
    if num.abs > 3
      cat_class = 'score-small-icon angry shorten'
    end
    image = ""
    image_class = "coolcat.png"
    if num < 0
      num = num.abs
      image_class = "negative-face.png"
    end

    image = image + (1..num).map do |_|
      image_tag(asset_path(image_class), class: cat_class)
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

  def render_nap_icon(cat_description)
    return "" if cat_description.nil?
    if cat_description.downcase.include?('nap')
      "💤"
    end
  end

  def render_subtype(subtype, show_text)
    text = show_text ? subtype : ''
    if subtype == 'brat'
      return "<text class='bratty color-brat'>#{image_tag(asset_path("brat.PNG"), class: 'tolerance angry shorten')} #{text} </text>"
    elsif subtype == 'curious'
      return "<text class='curious color-curious'>#{image_tag(asset_path("curious.PNG"), class: 'tolerance angry shorten')}️ #{text} </text>"
    elsif subtype == 'cuddly'
      return "<text class='cuddly color-cuddly'>#{image_tag(asset_path("cuddly.PNG"), class: 'tolerance angry shorten')}️ #{text} </text>"
    elsif subtype == 'furocious'
      return "<text class='furocious color-furocious'>#{image_tag(asset_path("furocious.PNG"), class: 'tolerance angry shorten')}️ #{text} </text>"
    # elsif subtype == 'conspirator'
    #   return "<text class='conspirator color-conspirator'><i class='fas fa-cat'></i>️ #{text} </text>"
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
    if (cat_image = CatImage.find_by(name: cat['title'])).present?
     return url_for(cat_image.avatar.variant(:thumb))
    end
    if cat["SELF"].present?
      image_url(cat["tile_image"])
    else
      cat["tile_image"]
    end
  end
end
