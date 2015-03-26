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

ActiveRecord::Schema.define(version: 20150325215457) do

  create_table "developers", force: :cascade do |t|
    t.string  "email",            limit: 255
    t.string  "location",         limit: 255
    t.string  "geolocation",      limit: 255
    t.string  "login",            limit: 255
    t.string  "name",             limit: 255
    t.boolean "hireable",         limit: 1
    t.text    "languages",        limit: 65535
    t.string  "gravatar_url",     limit: 255
    t.string  "secure_reference", limit: 255,   null: false
    t.string  "uid",              limit: 255
    t.string  "token",            limit: 255
  end

  create_table "indexed_users", force: :cascade do |t|
    t.string  "email",        limit: 255
    t.string  "location",     limit: 255
    t.string  "geolocation",  limit: 255
    t.string  "login",        limit: 255
    t.string  "name",         limit: 255
    t.boolean "hireable",     limit: 1
    t.text    "languages",    limit: 65535
    t.string  "gravatar_url", limit: 255
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "email", limit: 255
  end

end
