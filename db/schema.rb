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

ActiveRecord::Schema.define(version: 20140620203243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "cached_results"
    t.text     "cached_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations_technologies", id: false, force: true do |t|
    t.integer "location_id"
    t.integer "technology_id"
  end

  create_table "technologies", force: true do |t|
    t.string   "name"
    t.string   "search_regex"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locations_count"
  end

end
