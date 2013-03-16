class PhoneNumber < ActiveRecord::Base

  has_many :voicemails

  validate :incoming_number, :unique => true

  def self.import_numbers
    TwilioWrapper.instance.incoming_phone_numbers.each do |incoming_phone_number|
      find_or_create_for_incoming_number(incoming_phone_number)
    end
  end

  def self.find_or_create_for_incoming_number(incoming_number)
    where(:incoming_number => incoming_number).first || create_with_incoming_number!(incoming_number)
  end

  def self.create_with_incoming_number!(incoming_number)
    new.tap do |phone_number|
      phone_number.incoming_number = incoming_number
      phone_number.save!
    end
  end

  def self.null_object(attributes)
    NullPhoneNumber.new(attributes)
  end

  def forwarding?
    forwarding
  end

  def speakable_incoming_number
    incoming_number.gsub(/\D/, '').split('').join(", ")
  end

  def has_voicemail?
    false
  end

  class NullPhoneNumber
    attr_reader :incoming_number

    def initialize(attributes)
      @incoming_number = attributes[:incoming_number] || "unknown number"
    end

    def forwarding
      false
    end

    def has_voicemail?
      false
    end

    alias :forwarding? :forwarding
  end
end