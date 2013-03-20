class Voicemail < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  
  attr_accessible :call_sid, :from, :phone_number

  def self.for_call_sid(call_sid)
    where(call_sid: call_sid).limit(1).first || create(call_sid: call_sid)
  end

  belongs_to :phone_number

  def pretty_created_at
    if created_at > 12.hours.ago
      time_ago_in_words(created_at) + " ago"
    else
      created_at.strftime("%B %-d, %Y")
    end
  end

  def unread?
    !read
  end

  def mark_as_read
    self.read = true
    save
  end
end
