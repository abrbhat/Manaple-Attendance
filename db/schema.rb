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

ActiveRecord::Schema.define(version: 20141127180423) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "authorizations", force: true do |t|
    t.string   "permission"
    t.integer  "user_id"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["store_id"], name: "index_authorizations_on_store_id"
  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "leaves", force: true do |t|
    t.string   "status"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reason"
  end

  add_index "leaves", ["user_id"], name: "index_leaves_on_user_id"

  create_table "photos", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.string   "status"
    t.string   "ip"
    t.integer  "store_id"
  end

  add_index "photos", ["description"], name: "index_photos_on_description"
  add_index "photos", ["store_id"], name: "index_photos_on_store_id"
  add_index "photos", ["user_id"], name: "index_photos_on_user_id"

  create_table "stores", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "in_out_enabled"
    t.boolean  "mid_day_in_out_enabled"
    t.boolean  "mid_day_enabled"
    t.boolean  "employee_designation_enabled"
    t.boolean  "employee_code_enabled"
    t.boolean  "transfers_enabled"
    t.boolean  "leaves_enabled"
    t.boolean  "store_opening_mail_enabled"
    t.time     "in_time_start"
    t.time     "in_time_end"
    t.time     "out_time_start"
    t.time     "out_time_end"
    t.boolean  "is_evercookie_set"
    t.string   "evercookie_value"
  end

  create_table "transfers", force: true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from_store_id"
    t.integer  "to_store_id"
    t.integer  "user_id"
  end

  add_index "transfers", ["from_store_id"], name: "index_transfers_on_from_store_id"
  add_index "transfers", ["to_store_id"], name: "index_transfers_on_to_store_id"
  add_index "transfers", ["user_id"], name: "index_transfers_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                      default: "", null: false
    t.string   "encrypted_password",         default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "employee_code"
    t.text     "authentication_token"
    t.string   "employee_designation"
    t.string   "employee_status"
    t.string   "category"
    t.boolean  "receive_store_opening_mail"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
