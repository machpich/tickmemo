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

ActiveRecord::Schema.define(version: 20180302072715) do

  create_table "accounts", force: :cascade do |t|
    t.string "account_name"
    t.integer "character_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "details", force: :cascade do |t|
    t.integer "position_status"
    t.integer "account_id"
    t.integer "otherside_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "journal_id"
    t.index ["account_id"], name: "index_details_on_account_id"
    t.index ["journal_id"], name: "index_details_on_journal_id"
    t.index ["otherside_id"], name: "index_details_on_otherside_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "program"
    t.string "performer"
    t.date "date_start"
    t.date "date_end"
    t.string "image"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "events_locations", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "location_id", null: false
    t.index ["event_id"], name: "index_events_locations_on_event_id"
    t.index ["location_id"], name: "index_events_locations_on_location_id"
  end

  create_table "journals", force: :cascade do |t|
    t.date "trade_date"
    t.integer "figure"
    t.integer "trade_type_id"
    t.integer "schedule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "otherside_id"
    t.integer "user_id"
    t.index ["otherside_id"], name: "index_journals_on_otherside_id"
    t.index ["schedule_id"], name: "index_journals_on_schedule_id"
    t.index ["trade_type_id"], name: "index_journals_on_trade_type_id"
    t.index ["user_id"], name: "index_journals_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "place_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "memos", force: :cascade do |t|
    t.string "body"
    t.string "memoable_type"
    t.integer "memoable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "othersides", force: :cascade do |t|
    t.string "otherside_name"
    t.integer "type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_othersides_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.string "seat_type"
    t.boolean "fix"
    t.boolean "check"
    t.integer "location_id"
    t.integer "event_id"
    t.integer "otherside_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_schedules_on_event_id"
    t.index ["location_id"], name: "index_schedules_on_location_id"
    t.index ["otherside_id"], name: "index_schedules_on_otherside_id"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "trade_account_dicts", force: :cascade do |t|
    t.integer "position_status"
    t.integer "trade_type_id"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_trade_account_dicts_on_account_id"
    t.index ["trade_type_id"], name: "index_trade_account_dicts_on_trade_type_id"
  end

  create_table "trade_types", force: :cascade do |t|
    t.string "trade_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
