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

ActiveRecord::Schema.define(:version => 7) do

  create_table "articles", :force => true do |t|
    t.string   "title",                                              :null => false
    t.string   "abstract"
    t.text     "standfirst"
    t.text     "pullquote"
    t.text     "content"
    t.text     "footnote"
    t.string   "web_address"
    t.string   "status",                      :default => "NEW",     :null => false
    t.boolean  "featured",                    :default => true,      :null => false
    t.boolean  "print_only",                  :default => false,     :null => false
    t.string   "template",                    :default => "Normal",  :null => false
    t.string   "article_type",                :default => "Article", :null => false
    t.integer  "word_count",                  :default => 0,         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "section_id",                                         :null => false
    t.integer  "user_id",                                            :null => false
    t.text     "private_notes"
    t.integer  "publication_id"
    t.text     "properties"
    t.boolean  "review",                      :default => false,     :null => false
    t.integer  "review_rating",  :limit => 1
    t.string   "cached_authors"
    t.string   "cached_tags"
    t.string   "url",                                                :null => false
  end

  add_index "articles", ["review", "review_rating"], :name => "index_articles_review"
  add_index "articles", ["status", "starts_at", "ends_at", "print_only", "featured"], :name => "index_articles_main"
  add_index "articles", ["url"], :name => "index_articles_url"

  create_table "articles_events", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "event_id"
  end

  add_index "articles_events", ["article_id", "event_id"], :name => "index_articles_events_on_article_id_and_event_id", :unique => true

  create_table "articles_venues", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "venue_id"
  end

  add_index "articles_venues", ["article_id", "venue_id"], :name => "index_articles_venues_on_article_id_and_venue_id", :unique => true

  create_table "authors", :force => true do |t|
    t.integer "article_id",                :null => false
    t.integer "user_id"
    t.string  "name"
    t.integer "sort_order", :default => 0, :null => false
  end

  add_index "authors", ["article_id", "user_id"], :name => "index_authors_on_article_id_and_user_id", :unique => true
  add_index "authors", ["article_id"], :name => "index_authors_on_article_id"
  add_index "authors", ["user_id"], :name => "index_authors_on_user_id"

  create_table "owners", :id => false, :force => true do |t|
    t.integer "section_id"
    t.integer "user_id"
  end

  add_index "owners", ["section_id", "user_id"], :name => "index_owners_on_section_id_and_user_id", :unique => true

  create_table "sections", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "sections", ["name"], :name => "index_sections_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                :null => false
    t.string   "auth_method",                          :null => false
    t.string   "password_hash",                        :null => false
    t.string   "password_salt"
    t.string   "verification_key",                     :null => false
    t.boolean  "enabled",          :default => true,   :null => false
    t.boolean  "verified",         :default => false,  :null => false
    t.string   "name"
    t.string   "phone"
    t.string   "position"
    t.string   "country"
    t.string   "postcode"
    t.date     "date_of_birth"
    t.text     "profile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "accessed_at"
    t.boolean  "mailing_list",     :default => true,   :null => false
    t.string   "role",             :default => "USER", :null => false
  end

  add_index "users", ["email", "password_hash", "password_salt", "enabled", "verified", "mailing_list", "role"], :name => "index_users_main"
  add_index "users", ["email"], :name => "index_users_email", :unique => true

end
