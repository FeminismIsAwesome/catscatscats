# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_02_062951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_logs", force: :cascade do |t|
    t.bigint "cat_game_id"
    t.bigint "cat_player_id"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cat_game_id"], name: "index_activity_logs_on_cat_game_id"
    t.index ["cat_player_id"], name: "index_activity_logs_on_cat_player_id"
  end

  create_table "cat_cards", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "subtype"
    t.string "description"
    t.string "number_tl"
    t.string "number_tr"
    t.string "kind"
    t.boolean "self_hosted"
    t.text "tile_image"
    t.text "hover_description"
    t.integer "virtual_id"
  end

  create_table "cat_decks", force: :cascade do |t|
    t.bigint "cat_game_id"
    t.jsonb "discard_pile"
    t.jsonb "deck_pile"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "cats_discard_pile"
    t.jsonb "cats_draw_pile"
    t.jsonb "cat_player_order", default: []
    t.index ["cat_game_id"], name: "index_cat_decks_on_cat_game_id"
  end

  create_table "cat_games", force: :cascade do |t|
    t.string "ended_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "state", default: "drafting"
    t.bigint "current_player_id"
    t.jsonb "bids_placed", default: []
    t.jsonb "cards_played", default: []
    t.jsonb "players_passed", default: []
  end

  create_table "cat_players", force: :cascade do |t|
    t.bigint "cat_game_id"
    t.string "name"
    t.string "remote_id"
    t.integer "food", default: 0
    t.integer "toys", default: 0
    t.integer "catnip", default: 0
    t.integer "litterbox", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "owned_card_ids", default: []
    t.jsonb "hand_card_ids", default: []
    t.integer "energy_count", default: 0
    t.bigint "next_player_id"
    t.jsonb "actions_provided"
    t.integer "victory_points", default: 0
    t.integer "energy_maximum", default: 10
    t.integer "upkeeps_performed"
    t.index ["cat_game_id"], name: "index_cat_players_on_cat_game_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "email"
    t.boolean "ian_confirmed_legit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "playtester", default: false
    t.text "notes"
  end

  create_table "owned_cats", force: :cascade do |t|
    t.bigint "cat_player_id"
    t.bigint "cat_card_id"
    t.integer "happiness_level", default: 3
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cat_card_id"], name: "index_owned_cats_on_cat_card_id"
    t.index ["cat_player_id"], name: "index_owned_cats_on_cat_player_id"
  end

  create_table "shelter_cat_bids", force: :cascade do |t|
    t.bigint "cat_player_id"
    t.bigint "shelter_cat_id"
    t.integer "bid_amount", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cat_player_id"], name: "index_shelter_cat_bids_on_cat_player_id"
    t.index ["shelter_cat_id"], name: "index_shelter_cat_bids_on_shelter_cat_id"
  end

  create_table "shelter_cats", force: :cascade do |t|
    t.bigint "cat_game_id"
    t.bigint "cat_card_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cat_card_id"], name: "index_shelter_cats_on_cat_card_id"
    t.index ["cat_game_id"], name: "index_shelter_cats_on_cat_game_id"
  end

end
