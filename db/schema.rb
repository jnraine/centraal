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

ActiveRecord::Schema.define(:version => 20130326003617) do

  create_table "invites", :force => true do |t|
    t.integer  "phone_id"
    t.string   "token"
    t.string   "recipient"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "phones", :force => true do |t|
    t.boolean  "forwarding",         :default => false
    t.boolean  "voicemail",          :default => false
    t.boolean  "sms_notifications",  :default => false
    t.string   "forwarding_number"
    t.string   "incoming_number"
    t.string   "voicemail_greeting"
    t.string   "email"
    t.integer  "owner_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "sessions", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shortened_urls", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type", :limit => 20
    t.string   "url",                                     :null => false
    t.string   "unique_key", :limit => 10,                :null => false
    t.integer  "use_count",                :default => 0, :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "shortened_urls", ["owner_id", "owner_type"], :name => "index_shortened_urls_on_owner_id_and_owner_type"
  add_index "shortened_urls", ["unique_key"], :name => "index_shortened_urls_on_unique_key", :unique => true
  add_index "shortened_urls", ["url"], :name => "index_shortened_urls_on_url"

  create_table "twilio_clients", :force => true do |t|
    t.datetime "last_ping"
    t.integer  "phone_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "voicemails", :force => true do |t|
    t.string   "recording_url"
    t.string   "from"
    t.integer  "duration"
    t.string   "call_sid"
    t.integer  "phone_id"
    t.text     "transcription"
    t.boolean  "read",          :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

end
