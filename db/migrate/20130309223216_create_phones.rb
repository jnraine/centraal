class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.boolean :forwarding, default: false
      t.boolean :voicemail, default: false
      t.boolean :sms_notifications, default: false
      t.string :forwarding_number
      t.string :incoming_number
      t.string :voicemail_greeting
      t.string :email
      t.references :owner
      t.timestamps
    end
  end
end
