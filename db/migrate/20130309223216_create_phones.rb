class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.boolean :forwarding, default: false
      t.boolean :voicemail, default: false
      t.boolean :voicemail_notification_via_email, default: false
      t.boolean :voicemail_notification_via_sms, default: false
      t.string :forwarding_number
      t.string :incoming_number
      t.string :voicemail_greeting
      t.string :email
      t.references :user
      t.timestamps
    end
  end
end
