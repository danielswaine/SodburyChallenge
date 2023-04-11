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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20230324142846) do

  create_table "challenges", force: :cascade do |t|
    t.date     "date"
    t.integer  "time_allowed"
    t.text     "bonus_one"
    t.text     "bonus_two"
    t.text     "bonus_three"
    t.text     "bonus_four"
    t.text     "bonus_five"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "published",    default: false
  end

  create_table "checkpoints", force: :cascade do |t|
    t.integer  "number"
    t.string   "grid_reference"
    t.text     "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "checkpoints", ["number"], name: "index_checkpoints_on_number", unique: true

  create_table "goals", force: :cascade do |t|
    t.integer  "challenge_id"
    t.integer  "checkpoint_id"
    t.integer  "points_value"
    t.boolean  "compulsory",    default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "start_point",   default: false
  end

  create_table "members", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
  end

  add_index "members", ["team_id"], name: "index_members_on_team_id"

  create_table "messages", force: :cascade do |t|
    t.integer  "team_number"
    t.datetime "gps_fix_timestamp"
    t.text     "latitude"
    t.text     "longitude"
    t.text     "speed"
    t.string   "battery_voltage"
    t.integer  "rssi"
    t.text     "mobile_number"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "battery_level"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "score"
    t.string   "planned_start_time"
    t.string   "finish_time"
    t.string   "phone_in_time"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "challenge_id"
    t.integer  "group",              default: 0
    t.string   "actual_start_time"
    t.text     "visited"
    t.boolean  "disqualified",       default: false
    t.boolean  "dropped_out",        default: false
    t.boolean  "forgot_to_phone_in", default: false
  end

  add_index "teams", ["challenge_id", "planned_start_time"], name: "index_teams_on_challenge_id_and_planned_start_time", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.text     "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
