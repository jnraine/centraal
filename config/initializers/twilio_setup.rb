# Set Twilio settings if they are not already set
twilio_settings_path = Rails.root + "config/twilio.json"

if File.exists?(twilio_settings_path)
  twilio_settings = JSON.parse(File.read(twilio_settings_path))
  twilio_settings.each do |key, value|
    TwilioWrapper.instance.setting_set(key, value) if TwilioWrapper.instance.setting(key).nil?
  end
else
  Rails.logger.warn "Unable to find Twilio settings file: #{twilio_settings_path}"
  TWILIO_SETTINGS = {}
end