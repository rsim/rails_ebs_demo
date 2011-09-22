class SessionsController < ApplicationController

  def new
  end

  def create
    if user = User.authenticate(params[:user_name], params[:password])
      set_current_user(user)
      redirect_to employees_path
    else
      clear_current_user
      flash[:error] = 'Invalid user name or password'
      render :new
    end
  end

  def destroy
    clear_current_user
    redirect_to login_path
  end

end
