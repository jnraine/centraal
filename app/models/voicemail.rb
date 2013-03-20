class Voicemail < ActiveRecord::Base
  attr_accessible :call_sid, :from, :phone_number

  def self.for_call_sid(call_sid)
    where(call_sid: call_sid).limit(1).first || create(call_sid: call_sid)
  end

  belongs_to :phone_number
end
