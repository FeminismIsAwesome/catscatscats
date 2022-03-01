require 'csv'

class CatsController < ApplicationController

  def just_cards
    cat_index = params[:index].present? ? params[:index].to_i : 0
    cat_limit = params[:limit].present? ? params[:limit].to_i : 10000
    cat_type_filter = params[:type]
    @cats = Cat.get_cats('normal')[cat_index..(cat_limit+cat_index-1)]
    if cat_type_filter.present?
      @cats = @cats.select do |cat|
        cat['type'] == cat_type_filter
      end
    end
    if params[:pad] == "true"
      while @cats.length < 70
        @cats << @cats.first.dup
      end
    end
  end

  def printable
    redirect = params[:print]
    offset = params[:offset] || 0
    cat_limit = params[:limit] || 69
    pad = params[:pad] == "false" ? false : true
    if redirect == "cat"
      redirect_to just_cards_cats_path(index: offset, limit: cat_limit, pad: pad, type: 'cat')
    elsif redirect == "action1"
      redirect_to just_cards_cats_path(index: offset, limit: cat_limit, pad: pad, type: 'action')
    elsif redirect == "action2"
      redirect_to just_cards_cats_path(index: 69, limit: cat_limit, pad: pad, type: 'action')
    else
      redirect_to just_cards_cats_path(index: offset, limit: cat_limit, pad: pad)
    end
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
