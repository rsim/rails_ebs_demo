class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_user
  attr_accessor :current_user
  helper_method :current_user

  private

  def set_current_user(user = nil)
    if user
      session[:user_id] = user.id
      User.current = self.current_user = user
    elsif user_id = session[:user_id]
      User.current = self.current_user = User.find(user_id)
    else
      clear_current_user
    end
  end

  def clear_current_user
    User.current = self.current_user = nil
    session[:user_id] = nil
  end

  def login_required
    redirect_to login_path unless current_user
  end


end
