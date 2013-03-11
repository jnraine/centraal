class Voicemail < ActiveRecord::Base
  attr_accessible :call_sid, :from, :phone_number

  belongs_to :phone_number
end
