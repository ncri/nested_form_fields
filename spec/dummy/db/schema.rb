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

ActiveRecord::Schema.define(:version => 20120523095357) do

  create_table "projects", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "user_id"
  end

  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "todos", :force => true do |t|
    t.string  "description"
    t.integer "model_with_todos_id"
    t.string  "model_with_todos_type"
  end

  add_index "todos", ["model_with_todos_id"], :name => "index_todos_on_model_with_todos_id"
  add_index "todos", ["model_with_todos_type"], :name => "index_todos_on_model_with_todos_type"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
