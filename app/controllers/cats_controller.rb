require 'csv'

class CatsController < ApplicationController

  def just_cards
    cat_index = params[:index].present? ? params[:index].to_i : 0
    cat_limit = params[:limit].present? ? params[:limit].to_i : 10000
    cat_type_filter = params[:type]
    @cats = Cat.get_cats[cat_index..(cat_limit+cat_index)]
    if cat_type_filter.present?
      @cats = @cats.select do |cat|
        cat['type'] == cat_type_filter
      end
    end
    if params[:pad].present?
      while @cats.length < 70
        @cats << @cats.first.dup
      end
    end
  end

  def printable
    redirect_to just_cards_cats_path(index: 0, cat_limit: 69, pad: true, type: 'cat')
  end

  def index
    @email = Email.new
    @cats = Cat.get_cats
    @use_point_buy = false
  end

  def just_cards_image
    @cats = Cat.get_cats
    @kit = IMGKit.new(render_to_string)

    send_data(@kit.to_img('jpg'),
                :type => "image/jpg", :disposition => 'inline')
  end

end
