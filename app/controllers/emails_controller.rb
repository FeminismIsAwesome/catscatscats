class EmailsController < ApplicationController
  def create
    @email = Email.new(email_params)
    if @email.save
      redirect_to cats_path, notice: 'Email added! We will keep you up to date with progress.'
    else
      redirect_to cats_path, error: 'need an email to s ign up'
    end
  end

  private

  def email_params
    params.require(:email).permit(:email)
  end
end