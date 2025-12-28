create_table "discussions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
  t.string "title", null: false
  t.text "body", null: false

  t.uuid "book_id", null: false
  t.uuid "user_id", null: false

  # Optimization
  t.integer "comments_count", default: 0, null: false

  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false

  t.index ["book_id"], name: "index_discussions_on_book_id"
  t.index ["user_id"], name: "index_discussions_on_user_id"
end
