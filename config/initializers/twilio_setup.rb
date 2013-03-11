twilio_settings_path = Rails.root + "config/twilio.json"

if File.exists?(twilio_settings_path)
  TWILIO_SETTINGS = JSON.parse(File.read(twilio_settings_path))
else
  Rails.logger.warn "Unable to find Twilio settings file: #{twilio_settings_path}"
  TWILIO_SETTINGS = {}
end