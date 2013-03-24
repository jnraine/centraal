class CasUserFactory
  attr_accessor :auth_hash

  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def create
    User.new.tap do |u|
      u.login = login
      u.email = email 
      u.name = email
      u.save
    end
  end

  def login
    auth_hash["uid"]
  end

  def email
    "#{login}@sfu.ca"
  end
end
