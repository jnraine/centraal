class Phone < ActiveRecord::Base
  attr_accessible :forwarding_number, :voicemail, :forwarding, :sms_notifications

  has_many :voicemails, order: "created_at DESC"
  has_many :clients, class_name: TwilioClient
  has_many :connected_clients, class_name: TwilioClient, conditions: proc { "last_ping > '#{5.minutes.ago}'" }

  belongs_to :owner, class_name: "User"

  validate :incoming_number, unique: true
  validates_each :incoming_number, :forwarding_number do |record, attr, value|
    record.errors.add(attr, "is invalid. Try something like (123) 555-1234.") unless valid_number?(value) or value.blank?
  end

  def self.sync_numbers
    TwilioWrapper.instance.incoming_numbers.each do |incoming_number|
      find_or_create_for_incoming_number(incoming_number)
    end
  end

  def self.find_or_create_for_incoming_number(incoming_number)
    where(incoming_number: incoming_number).first || create_with_incoming_number!(incoming_number)
  end

  def self.create_with_incoming_number!(incoming_number)
    new.tap do |phone|
      phone.incoming_number = incoming_number
      phone.save!
    end
  end

  def self.for_incoming_number(incoming_number)
    Phone.where(incoming_number: incoming_number).first || Phone.null_object(incoming_number: incoming_number)
  end

  def self.null_object(attributes)
    NullPhone.new(attributes)
  end

  def self.speakable_number(number)
    number.gsub(/\D/, '').split('').join(", ")
  end

  def self.valid_number?(number)
    return true if number.nil?
    !!number.match(/\+\d{7}/)
  end

  def self.format_number(number)
    formatted = number.gsub(/\D/, "")
    return number if formatted.length < 10
    formatted = "1#{formatted}" if formatted.length == 10
    formatted = "+#{formatted}" if formatted.length == 11
    formatted
  end

  def forwarding?
    forwarding
  end

  def speakable_incoming_number
    self.class.speakable_number(incoming_number)
  end

  def voicemail_on?
    voicemail
  end

  def incoming_number=(number)
    super self.class.format_number(number)
  end

  def forwarding_number=(number)
    super self.class.format_number(number)
  end

  def connect_client
    client = clients.create
    client.ping
  end

  def client
    clients.first || clients.create
  end

  def notify_user_of_voicemail(voicemail)
    send_voicemail_notification_via_sms(voicemail) if sms_notifications
  end

  def send_voicemail_notification_via_sms(voicemail)
    short_url = shorten_url(voicemail.recording_url)
    message = "New voicemail from #{voicemail.from}. Listen here: #{short_url}"
    TwilioWrapper.instance.send_sms(from: incoming_number, to: forwarding_number, body: message)
  end

  # This method shouldn't live here. No way bro.
  def shorten_url(url)
    Rails.application.routes.url_helpers.shortener_translate_url(Shortener::ShortenedUrl.generate(url))
  end

  class NullPhone
    attr_reader :incoming_number

    def initialize(attributes)
      @incoming_number = attributes[:incoming_number] || "unknown number"
    end

    def speakable_incoming_number
      Phone.speakable_number(incoming_number)
    end

    def forwarding
      false
    end

    def voicemail_on?
      false
    end

    alias :forwarding? :forwarding
  end
end
