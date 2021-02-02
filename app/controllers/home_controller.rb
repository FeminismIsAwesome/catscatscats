class HomeController < ApplicationController

  def new
    @email = Email.new
  end
end
