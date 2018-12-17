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

ActiveRecord::Schema.define(version: 2018_12_17_135115) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace", limit: 255
    t.text "body"
    t.string "resource_id", limit: 255, null: false
    t.string "resource_type", limit: 255, null: false
    t.integer "author_id"
    t.string "author_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_email_campaigns", force: :cascade do |t|
    t.string "template_name"
    t.string "var1_name", default: "first_name"
    t.string "var1_value", default: "first_name"
    t.string "var2_name"
    t.string "var2_value"
    t.string "var3_name"
    t.string "var3_value"
    t.string "recipients"
    t.boolean "published_bloomeurs", default: false
    t.boolean "finished", default: false
    t.text "logs_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "bloomies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "first_name"
    t.integer "age"
    t.string "source"
    t.string "authentication_token", limit: 30
    t.string "name"
    t.boolean "coached", default: false
    t.string "company_name"
    t.boolean "cgu_accepted"
    t.index ["authentication_token"], name: "index_bloomies_on_authentication_token", unique: true
    t.index ["email"], name: "index_bloomies_on_email", unique: true
    t.index ["reset_password_token"], name: "index_bloomies_on_reset_password_token", unique: true
  end

  create_table "books", force: :cascade do |t|
    t.string "author"
    t.string "isbn"
    t.string "title"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "asin"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
  end

  create_table "books_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "book_id", null: false
    t.index ["book_id", "user_id"], name: "index_books_users_on_book_id_and_user_id", unique: true
  end

  create_table "bundles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_bundles_on_name", unique: true
  end

  create_table "bundles_campaigns", force: :cascade do |t|
    t.integer "bundle_id"
    t.integer "campaign_id"
    t.decimal "price", null: false
    t.index ["bundle_id", "campaign_id"], name: "index_bundles_campaigns_on_bundle_id_and_campaign_id", unique: true
  end

  create_table "bundles_contracts", force: :cascade do |t|
    t.integer "bundle_id"
    t.integer "contract_id"
    t.index ["bundle_id", "contract_id"], name: "index_bundles_contracts_on_bundle_id_and_contract_id", unique: true
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "partner"
    t.decimal "standard_price"
    t.string "campaign_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "premium_price"
  end

  create_table "campaigns_program_templates", force: :cascade do |t|
    t.decimal "price", null: false
    t.integer "campaign_id"
    t.integer "program_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["campaign_id", "program_template_id"], name: "campaigns_program_template_index", unique: true
    t.index ["campaign_id"], name: "index_campaigns_program_templates_on_campaign_id"
    t.index ["program_template_id"], name: "index_campaigns_program_templates_on_program_template_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenges_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "challenge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_challenges_users_on_challenge_id"
    t.index ["user_id", "challenge_id"], name: "index_challenges_users_on_user_id_and_challenge_id", unique: true
    t.index ["user_id"], name: "index_challenges_users_on_user_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.string "company_name", null: false
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_name"], name: "index_contracts_on_company_name", unique: true
    t.index ["key"], name: "index_contracts_on_key", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "impressions", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "params"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "keyword_associations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["keyword_id"], name: "index_keyword_associations_on_keyword_id"
    t.index ["user_id"], name: "index_keyword_associations_on_user_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "tag", limit: 255
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "tribe_id"
    t.string "normalized_tag"
    t.index ["normalized_tag"], name: "index_keywords_on_normalized_tag", unique: true
    t.index ["tribe_id"], name: "index_keywords_on_tribe_id"
  end

  create_table "missions", force: :cascade do |t|
    t.string "prismic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prismic_id"], name: "index_missions_on_prismic_id", unique: true
  end

  create_table "missions_programs", id: false, force: :cascade do |t|
    t.integer "mission_id", null: false
    t.integer "program_id", null: false
    t.index ["program_id", "mission_id"], name: "index_missions_programs_on_program_id_and_mission_id"
  end

  create_table "program_templates", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "discourse", null: false
    t.boolean "intercom", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bundle_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bloomy_id"
    t.boolean "discourse", default: false
    t.boolean "intercom", default: false
    t.datetime "ended_at"
    t.datetime "started_at"
    t.index ["bloomy_id"], name: "index_programs_on_bloomy_id"
  end

  create_table "question_comments", force: :cascade do |t|
    t.string "author_avatar_url", limit: 255
    t.string "author_name", limit: 255, null: false
    t.text "comment", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "question_id"
    t.boolean "published", default: true
    t.index ["question_id"], name: "index_question_comments_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.text "answer"
    t.string "identifier", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "position", limit: 255
    t.boolean "published", default: false
    t.string "description"
    t.string "step"
    t.boolean "mandatory", default: false
    t.index ["identifier"], name: "index_questions_on_identifier"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "strengths", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strengths_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "strength_id", null: false
    t.index ["strength_id", "user_id"], name: "index_strengths_users_on_strength_id_and_user_id", unique: true
  end

  create_table "testimonies", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.string "person"
    t.string "date"
    t.string "position", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "tribes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "normalized_name"
  end

  create_table "tribes_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "tribe_id", null: false
    t.index ["tribe_id", "user_id"], name: "index_tribes_users_on_tribe_id_and_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "first_name", limit: 255
    t.string "job_title", limit: 255
    t.string "avatar_file_name", limit: 255
    t.string "avatar_content_type", limit: 255
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "published", default: false
    t.boolean "do_authorize", default: false
    t.string "normalized_job_title"
    t.string "normalized_first_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["normalized_job_title", "normalized_first_name"], name: "index_users_on_normalized_job_title_and_normalized_first_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
