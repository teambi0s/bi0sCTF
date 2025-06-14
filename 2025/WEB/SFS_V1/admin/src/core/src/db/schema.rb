
ActiveRecord::Schema[8.0].define(version: 2025_04_13_170349) do
  create_table "legacies", force: :cascade do |t|
    t.string "legacy_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "isolated"
    t.boolean "random"
    t.boolean "extension"
    t.string "file_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "url"
    t.boolean "validated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "settings", "users"
end
