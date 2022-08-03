class EmailsController < ApplicationController
  def create
    @email = Email.new(email_params)
    if @email.save
      redirect_to new_email_path, notice: 'Email added! We will keep you up to date with progress.'
    else
      render :new
    end
  end

  def new
    redirect_to "https://www.kickstarter.com/projects/winniethekitty/kitty-committee?ref=user_menu"
    return

    @email = Email.new
    cats = Cat.get_cats
    @cats = [cats.find do |cat|
      cat['title'] == 'NO!'
    end]
    @cats += cats.select do |cat|
      cat['title'].in? ["Selena", "Serious Cat-titude", "Push off the table", "Lucy", "Selectively Nice"]
    end
    @winnie = cats.find do |cat|
      cat['title'].include?("Winnie")
    end
  end

  private

  def email_params
    params.require(:email).permit(:email, :name, :playtester, :notes)
  end
end