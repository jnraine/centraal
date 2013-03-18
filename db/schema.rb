# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130311082243) do

  create_table "phone_numbers", :force => true do |t|
    t.boolean  "forwarding",         :default => false
    t.boolean  "voicemail",          :default => false
    t.string   "forwarding_number"
    t.string   "incoming_number"
    t.string   "voicemail_greeting"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "voicemails", :force => true do |t|
    t.string   "recording_url"
    t.string   "from"
    t.integer  "duration"
    t.string   "call_sid"
    t.integer  "phone_number_id"
    t.text     "transcription"
    t.boolean  "read",            :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

end
