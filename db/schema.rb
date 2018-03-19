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

ActiveRecord::Schema.define(version: 20180319135338) do

  create_table "appointments", force: :cascade do |t|
    t.integer  "doctor_id",   limit: 4
    t.integer  "patient_id",  limit: 4
    t.datetime "date"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "status",      limit: 4, default: 0
    t.time     "start_time"
    t.time     "finish_time"
  end

  create_table "doctor_profiles", force: :cascade do |t|
    t.integer  "doctor_id",            limit: 4
    t.time     "appointment_duration"
    t.integer  "experience",           limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "doctorprofiles", force: :cascade do |t|
    t.integer  "doctor_id",            limit: 4
    t.time     "appointment_duration"
    t.integer  "experience",           limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id",   limit: 4
    t.string   "imageable_type", limit: 255
    t.string   "image",          limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string   "description",    limit: 255
    t.integer  "user_id",        limit: 4
    t.integer  "appointment_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "slots", force: :cascade do |t|
    t.integer  "appointment_id",   limit: 4
    t.time     "start_time",       limit: 6
    t.time     "finish_time"
    t.date     "appointment_date"
    t.integer  "doctor_id",        limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "gender",                 limit: 255
    t.datetime "date_of_birth"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "role",                   limit: 4,   default: 1
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "oauth_token",            limit: 255
    t.datetime "oauth_expires_at"
  end

  add_index "users", ["id"], name: "index_users_on_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
