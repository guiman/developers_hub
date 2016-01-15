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

ActiveRecord::Schema.define(version: 20160113211935) do

  create_table "dev_recruiters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "uid",        limit: 255,                     null: false
    t.string   "avatar_url", limit: 255
    t.string   "token",      limit: 255
    t.string   "email",      limit: 255
    t.string   "location",   limit: 255, default: "unknown"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "beta_user",  limit: 1,   default: true,      null: false
  end

  create_table "developer_skills", force: :cascade do |t|
    t.integer "developer_id", limit: 4
    t.integer "skill_id",     limit: 4
    t.integer "strength",     limit: 4
    t.string  "code_example", limit: 255, default: ""
    t.string  "origin",       limit: 255, default: "github"
  end

  add_index "developer_skills", ["developer_id"], name: "index_developer_skills_on_developer_id", using: :btree
  add_index "developer_skills", ["skill_id"], name: "index_developer_skills_on_skill_id", using: :btree

  create_table "developer_watchers", force: :cascade do |t|
    t.integer  "developer_id",     limit: 4
    t.integer  "dev_recruiter_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "developers", force: :cascade do |t|
    t.string   "email",                      limit: 255
    t.string   "location",                   limit: 255
    t.string   "geolocation",                limit: 255
    t.string   "login",                      limit: 255
    t.string   "name",                       limit: 255
    t.boolean  "hireable",                   limit: 1
    t.text     "languages",                  limit: 65535
    t.string   "gravatar_url",               limit: 255
    t.string   "secure_reference",           limit: 255,                   null: false
    t.string   "uid",                        limit: 255
    t.string   "token",                      limit: 255
    t.integer  "developer_skills_count",     limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",                     limit: 1,     default: false
    t.text     "activity",                   limit: 65535
    t.boolean  "needs_update_activity",      limit: 1,     default: true
    t.boolean  "needs_update_contributions", limit: 1,     default: true
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

  create_table "subscribers", force: :cascade do |t|
    t.string "email", limit: 255
  end

  add_foreign_key "developer_skills", "developers"
  add_foreign_key "developer_skills", "skills"
end
