class CreateTwilioClients < ActiveRecord::Migration
  def change
    create_table :twilio_clients do |t|
      t.datetime :last_ping
      t.string :client_type
      t.references :phone_number
      t.timestamps
    end
  end
end
