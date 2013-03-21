class PhoneNumber < ActiveRecord::Base
  attr_accessible :forwarding_number, :voicemail, :forwarding

  has_many :voicemails, order: "created_at DESC"
  has_many :clients, class_name: TwilioClient
  has_many :connected_clients, class_name: TwilioClient, conditions: proc { "last_ping > '#{5.minutes.ago}'" }

  validate :incoming_number, unique: true
  validates_each :incoming_number, :forwarding_number do |record, attr, value|
    record.errors.add(attr, "is invalid. Try something like 123-555-1234.") unless valid_number?(value)
  end

  def self.sync_numbers
    TwilioWrapper.instance.incoming_phone_numbers.each do |incoming_phone_number|
      find_or_create_for_incoming_number(incoming_phone_number)
    end
  end

  def self.find_or_create_for_incoming_number(incoming_number)
    where(incoming_number: incoming_number).first || create_with_incoming_number!(incoming_number)
  end

  def self.create_with_incoming_number!(incoming_number)
    new.tap do |phone_number|
      phone_number.incoming_number = incoming_number
      phone_number.save!
    end
  end

  def self.for_incoming_number(incoming_phone_number)
    PhoneNumber.where(incoming_number: incoming_phone_number).first || PhoneNumber.null_object(incoming_number: incoming_phone_number)
  end

  def self.null_object(attributes)
    NullPhoneNumber.new(attributes)
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

  def connect_client(type)
    client = create_client(type)
    client.ping
    client.save
  end

  def client(type)
    clients.where(client_type: type).first || create_client(type)
  end

  def create_client(type)
    client = clients.build(client_type: type)
    client.save
    client
  end

  class NullPhoneNumber
    attr_reader :incoming_number

    def initialize(attributes)
      @incoming_number = attributes[:incoming_number] || "unknown number"
    end

    def speakable_incoming_number
      PhoneNumber.speakable_number(incoming_number)
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
