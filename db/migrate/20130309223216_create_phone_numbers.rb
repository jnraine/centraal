class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.boolean :forwarding, :default => false
      t.boolean :voicemail, :default => false
      t.string :forwarding_number
      t.string :incoming_number
      t.string :voicemail_greeting
      t.string :email
      t.timestamps
    end
  end
end
