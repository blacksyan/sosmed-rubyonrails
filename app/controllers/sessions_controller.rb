class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log the user in and redirect to profile page
      log_in user
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email or password combination.'
      render 'new'
      # error message
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
