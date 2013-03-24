class SessionsController < ApplicationController
  skip_filter :require_login, :only => [:create]

  def create
    @user = retrieve_user
    session[:id] = @user.valid_session.id

    if @user.permitted?
      flash[:notice] = "You are now logged in as #{@user.login}"
      redirect_to params["redirect"] || root_path
    else
      current_session.destroy
      render "sessions/not_permitted", :layout => false
    end
  end

  def destroy
    current_session.destroy
    redirect_to "https://cas.sfu.ca/cgi-bin/WebObjects/cas.woa/wa/applogout?app=Centraal"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def retrieve_user
    factory_klass = USER_FACTORIES[params["provider"]]
    raise "User factory for #{params["provider"]} provider not found" if factory_klass.blank?
    factory = factory_klass.new(auth_hash)
    User.find_or_create_with_factory(factory)
  end
end
