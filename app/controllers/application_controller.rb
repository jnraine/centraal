class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login

  def redirect_to_phone
    raise "I'm not implemented yet"
    redirect_to phone_path(current_user.phones.first)
  end

  private
  
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
