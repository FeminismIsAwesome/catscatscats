module ApplicationHelper

  def render_cat_line(line)
    line = line.gsub(':butthole:', image_tag(asset_path("tolerance.jpeg"), class: 'tolerance'))
    line = line.gsub(/[pP]issed/, image_tag(asset_path("pissedreplace.png"), class: 'tolerance angry'))
    line = line.gsub('VP', image_tag(asset_path("coolcat.png"), class: 'tolerance angry shorten'))
    line.gsub(/[iI]nfluence/, image_tag(asset_path("money"), class: 'fish'))
  end

  def get_tile_image(cat)
    if cat["SELF"].present?
      image_url(cat["tile_image"])
    else
      cat["tile_image"]
    end
  end
end
