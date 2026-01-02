# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_01_02_093410) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.text "biography"
    t.string "website"
    t.string "social_handle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_authors_on_id"
  end

  create_table "books", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.string "language", null: false
    t.string "edition"
    t.string "publisher"
    t.integer "page_count", null: false
    t.date "published_at", null: false
    t.string "isbn"
    t.boolean "featured", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "author_id"
    t.uuid "category_id"
    t.boolean "recommended", default: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["category_id"], name: "index_books_on_category_id"
    t.index ["title"], name: "index_books_on_title", unique: true
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_categories_on_id"
  end

  create_table "cities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "country_code", limit: 2, null: false
    t.string "name", null: false
    t.string "state_province"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.integer "population"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_code", "name"], name: "index_cities_on_country_code_and_name"
    t.index ["country_code"], name: "index_cities_on_country_code"
    t.index ["name"], name: "index_cities_on_name"
  end

  create_table "comment_likes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "comment_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id", "user_id"], name: "index_comment_likes_on_comment_id_and_user_id", unique: true
    t.index ["comment_id"], name: "index_comment_likes_on_comment_id"
    t.index ["user_id"], name: "index_comment_likes_on_user_id"
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "discussion_id"
    t.uuid "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.integer "likes_count", default: 0, null: false
    t.integer "status", default: 0
    t.datetime "deleted_at"
    t.uuid "deleted_by_id"
    t.string "deletion_reason"
    t.boolean "deleted", default: false, null: false
    t.index ["deleted"], name: "index_comments_on_deleted"
    t.index ["deleted_at"], name: "index_comments_on_deleted_at"
    t.index ["deleted_by_id"], name: "index_comments_on_deleted_by_id"
    t.index ["discussion_id"], name: "index_comments_on_discussion_id"
    t.index ["likes_count"], name: "index_comments_on_likes_count"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "countries", primary_key: "code", id: { type: :string, limit: 2 }, force: :cascade do |t|
    t.string "name", null: false
    t.string "iso3", limit: 3
    t.string "numeric_code", limit: 3
    t.string "capital"
    t.string "currency_code", limit: 3
    t.string "phone_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_countries_on_name"
  end

  create_table "discussions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.uuid "book_id"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "status", default: 0
    t.boolean "deleted", default: false
    t.datetime "deleted_at"
    t.uuid "deleted_by_id"
    t.string "deletion_reason"
    t.index ["book_id"], name: "index_discussions_on_book_id"
    t.index ["deleted"], name: "index_discussions_on_deleted"
    t.index ["deleted_at"], name: "index_discussions_on_deleted_at"
    t.index ["deleted_by_id"], name: "index_discussions_on_deleted_by_id"
    t.index ["user_id"], name: "index_discussions_on_user_id"
  end

  create_table "favorites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_favorites_on_book_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "languages", primary_key: "code", id: { type: :string, limit: 2 }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "recipient_id", null: false
    t.uuid "actor_id", null: false
    t.string "action", null: false
    t.string "notifiable_type", null: false
    t.uuid "notifiable_id", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_id", "read_at"], name: "index_notifications_on_recipient_id_and_read_at"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "reading_positions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "book_id", null: false
    t.integer "page_number", null: false
    t.float "scroll_offset"
    t.float "percentage_completed"
    t.datetime "last_read_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reading_positions_on_book_id"
    t.index ["last_read_at"], name: "index_reading_positions_on_last_read_at"
    t.index ["user_id", "book_id"], name: "index_reading_positions_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_reading_positions_on_user_id"
  end

  create_table "reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "reporter_id", null: false
    t.string "reportable_type", null: false
    t.uuid "reportable_id", null: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable"
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.bigint "phone", null: false
    t.string "address", default: "", null: false
    t.string "gender", default: "unspecified", null: false
    t.date "date_of_birth", null: false
    t.string "jti", null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country_code", limit: 2, null: false
    t.uuid "city_id", null: false
    t.datetime "activated_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "email_notifications", default: true, null: false
    t.integer "role", default: 0
    t.index ["activated_at"], name: "index_users_on_activated_at"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["status"], name: "index_users_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "categories"
  add_foreign_key "cities", "countries", column: "country_code", primary_key: "code"
  add_foreign_key "comment_likes", "comments"
  add_foreign_key "comment_likes", "users"
  add_foreign_key "comments", "users", column: "deleted_by_id"
  add_foreign_key "discussions", "users", column: "deleted_by_id"
  add_foreign_key "favorites", "books"
  add_foreign_key "favorites", "users"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "reading_positions", "books"
  add_foreign_key "reading_positions", "users"
  add_foreign_key "reports", "users", column: "reporter_id"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "countries", column: "country_code", primary_key: "code"
end
