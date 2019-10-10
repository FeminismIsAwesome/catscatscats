require 'csv'

class CatsController < ApplicationController

  def index
    cats_path = Rails.root.join('config', 'cats.csv')
    cat_ordering = {
        "award" => 0,
        "cat" => 2,
        "greed" => 5,
        "starter" => 3,
        "positive" => 4,
        "negative" => 6,
        "action" => 1
    }
    @cats = CSV.read(cats_path,headers: true).sort_by do
      | cat |
      cat_order = cat_ordering[cat["type"]]
      if cat_order.present?
        cat_order
      else
        cat['description'].present? ? cat['description'].length : 1000
      end
    end
    @use_point_buy = false
  end

end
