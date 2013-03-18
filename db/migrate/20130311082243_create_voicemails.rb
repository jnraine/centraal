class CreateVoicemails < ActiveRecord::Migration
  def change
    create_table :voicemails do |t|
      t.string :recording_url
      t.string :from
      t.integer :duration
      t.string :call_sid
      t.references :phone_number
      t.text :transcription
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
