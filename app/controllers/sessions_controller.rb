class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or users_path
    else
      flash.now[:danger] = 'Incorrect email address or password.'
      render 'new'
    end
  end

  def destroy
    if logged_in?
      log_out
      flash[:success] = "You have been logged out."
    end
    redirect_to root_url
  end
end
