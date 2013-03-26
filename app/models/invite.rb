class Invite < ActiveRecord::Base
  attr_accessible :phone_id, :recipient

  belongs_to :phone

  before_create :generate_token

  def self.for_token(token)
    where(token: token).first
  end

  def generate_token
    o =  [('a'..'z'), ('A'..'Z')].map {|i| i.to_a }.flatten
    self.token = 50.times.map { o[rand(o.length)] }.join
  end
end
