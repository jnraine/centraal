require 'digest/md5'

class User < ActiveRecord::Base
  attr_accessible :login

  has_many :sessions

  def self.for_session_id(session_id)
    session = Session.where(:id => session_id).first
    session.user if session.present?
  end

  def self.find_or_create_with_factory(factory)
    User.where(login: factory.login).first || factory.create
  end

  def email_md5
    return :no_email if email.blank?
    Digest::MD5.hexdigest(email.downcase)
  end

  def avatar_url(size = :tiny)
    sizes = {tiny: 35, small: 75, medium: 200, large: 400}
    "http://www.gravatar.com/avatar/#{email_md5}?d=retro&s=#{sizes[size]}"
  end

  def valid_session
    sessions.last || sessions.create
  end

  def permitted?
    true
  end
end
