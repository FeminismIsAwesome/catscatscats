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
    @email = Email.new
    cats = Cat.get_cats
    @cats = [cats.find do |cat|
      cat['title'] == 'NO!'
    end]
    @cats += cats.select do |cat|
      cat['title'] == "Selena" || cat['title'] == "Serious Cat-titude" || cat['title'] == "Push off the table"
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