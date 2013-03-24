class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login

  def front_door_redirect
    if current_user.phones.present?
      redirect_to user_phone_path
    elsif current_user.admin?
      redirect_to phones_path
    else
      redirect_to zero_phones_path
    end
  end

  private
  
  def require_admin
    redirect_to front_door_redirect unless current_user.admin?
  end

  def require_login
    redirect_to cas_login_path if current_user.blank?
  end

  def current_user
    @current_user ||= User.for_session_id(session[:id])
  end

  def current_session
    @current_session ||= Session.where(:id => session[:id]).first
  end

  def cas_login_path
    "/auth/cas?redirect=#{request.path}"
  end
end
