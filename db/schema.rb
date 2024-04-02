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

ActiveRecord::Schema[7.1].define(version: 2024_04_02_174717) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "employment_type", ["FULLTIME", "PARTTIME"]
  create_enum "skill_type", ["PERSONAL", "TECHNICAL"]
  create_enum "user_type", ["SEEKER", "TRAINING_PROVIDER"]

  create_table "_prisma_migrations", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "checksum", limit: 64, null: false
    t.timestamptz "finished_at"
    t.string "migration_name", limit: 255, null: false
    t.text "logs"
    t.timestamptz "rolled_back_at"
    t.timestamptz "started_at", default: -> { "now()" }, null: false
    t.integer "applied_steps_count", default: 0, null: false
  end

  create_table "accounts", id: :text, force: :cascade do |t|
    t.text "user_id", null: false
    t.text "type", null: false
    t.text "provider", null: false
    t.text "provider_account_id", null: false
    t.text "refresh_token"
    t.text "access_token"
    t.integer "expires_at"
    t.text "token_type"
    t.text "scope"
    t.text "id_token"
    t.text "session_state"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["provider", "provider_account_id"], name: "Account_provider_provider_account_id_key", unique: true
  end

  create_table "applicant_analytics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "applicant_id", null: false
    t.text "job_id", null: false
    t.text "employer_id", null: false
    t.string "employer_name"
    t.string "employment_title"
    t.string "applicant_name"
    t.string "applicant_email"
    t.string "status"
    t.integer "days"
    t.integer "hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "applicant_created_at"
    t.index ["applicant_id"], name: "index_applicant_analytics_on_applicant_id"
    t.index ["employer_id"], name: "index_applicant_analytics_on_employer_id"
    t.index ["job_id"], name: "index_applicant_analytics_on_job_id"
  end

  create_table "applicant_chats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "applicant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_applicant_chats_on_applicant_id", unique: true
  end

  create_table "applicant_status_reasons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "applicant_status_id", null: false
    t.uuid "reason_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "response"
    t.index ["applicant_status_id"], name: "index_applicant_status_reasons_on_applicant_status_id"
    t.index ["reason_id"], name: "index_applicant_status_reasons_on_reason_id"
  end

  create_table "applicant_statuses", id: :text, force: :cascade do |t|
    t.text "applicant_id", null: false
    t.text "status", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "applicants", id: :text, force: :cascade do |t|
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.uuid "seeker_id", null: false
    t.string "elevator_pitch"
    t.index ["seeker_id", "job_id"], name: "index_applicants_on_seeker_id_and_job_id", unique: true
    t.index ["seeker_id"], name: "index_applicants_on_seeker_id"
  end

  create_table "barriers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "barrier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barrier_id"], name: "index_barriers_on_barrier_id", unique: true
  end

  create_table "career_paths", id: :text, force: :cascade do |t|
    t.text "title", null: false
    t.text "upper_limit", null: false
    t.text "lower_limit", null: false
    t.integer "order", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "chat_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "applicant_chat_id", null: false
    t.text "user_id", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_chat_id"], name: "index_chat_messages_on_applicant_chat_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "coach_seeker_contexts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "assigned_coach"
    t.string "skill_level"
    t.string "stage"
    t.datetime "last_contacted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_active_on"
    t.uuid "seeker_id"
    t.string "certified_by"
    t.string "kind", null: false
    t.string "lead_captured_by"
    t.string "context_id", null: false
    t.datetime "seeker_captured_at", null: false
    t.index ["context_id"], name: "index_coach_seeker_contexts_on_context_id", unique: true
  end

  create_table "coaches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "coach_id"
    t.float "assignment_weight", default: 1.0, null: false
  end

  create_table "coaches_feed_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "context_id", null: false
    t.string "seeker_email", null: false
    t.text "description", null: false
    t.datetime "occurred_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coaches_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "job_id", null: false
    t.string "employment_title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "employer_name"
    t.boolean "hide_job", default: false, null: false
    t.index ["job_id"], name: "index_coaches_jobs_on_job_id"
  end

  create_table "coaches_seeker_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "coach_seeker_context_id", null: false
    t.uuid "application_id", null: false
    t.string "employment_title", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "employer_name"
    t.uuid "job_id"
    t.index ["application_id"], name: "index_coaches_seeker_applications_on_application_id"
    t.index ["coach_seeker_context_id"], name: "index_coaches_seeker_applications_on_coach_seeker_context_id"
  end

  create_table "coaches_seeker_job_recommendations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "coach_seeker_context_id", null: false
    t.uuid "coach_id", null: false
    t.uuid "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id"], name: "index_coaches_seeker_job_recommendations_on_coach_id"
    t.index ["coach_seeker_context_id"], name: "index_seeker_job_recommendations_on_coach_seeker_context_id"
    t.index ["job_id"], name: "index_coaches_seeker_job_recommendations_on_job_id"
  end

  create_table "credentials", id: :text, force: :cascade do |t|
    t.text "organization_id"
    t.text "name"
    t.text "description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.text "issued_date"
    t.uuid "seeker_id", null: false
  end

  create_table "desired_certifications", id: :text, force: :cascade do |t|
    t.text "master_certification_id", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "desired_skills", id: :text, force: :cascade do |t|
    t.text "master_skill_id", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "education_experiences", id: :text, force: :cascade do |t|
    t.text "organization_id"
    t.text "organization_name"
    t.text "title"
    t.text "activities"
    t.text "graduation_date"
    t.text "gpa"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.uuid "seeker_id", null: false
    t.index ["seeker_id"], name: "index_education_experiences_on_seeker_id"
  end

  create_table "employer_invites", id: :text, force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "employer_id", null: false
    t.datetime "used_at", precision: 3
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "employers", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "location"
    t.text "bio", null: false
    t.text "logo_url"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.boolean "chat_enabled", default: false, null: false
  end

  create_table "employers_applicant_status_reasons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "employers_applicant_id", null: false
    t.string "reason", null: false
    t.string "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employers_applicant_id"], name: "index_emp_applicant_status_reasons_on_emp_applicant_id"
  end

  create_table "employers_applicants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "applicant_id", null: false
    t.uuid "seeker_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.string "status", null: false
    t.uuid "employers_job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "status_as_of"
    t.string "certified_by"
    t.index ["employers_job_id"], name: "index_employers_applicants_on_employers_job_id"
    t.index ["seeker_id", "employers_job_id"], name: "index_employers_applicants_on_seeker_id_and_employers_job_id", unique: true
  end

  create_table "employers_employers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "location"
    t.string "bio", null: false
    t.string "logo_url"
    t.string "employer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employers_job_owners", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "employers_recruiter_id", null: false
    t.uuid "employers_job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employers_job_id"], name: "index_employers_job_owners_on_employers_job_id"
    t.index ["employers_recruiter_id"], name: "index_employers_job_owners_on_employers_recruiter_id"
  end

  create_table "employers_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "job_id", null: false
    t.string "employment_title", null: false
    t.string "benefits_description", null: false
    t.string "employment_type", null: false
    t.boolean "hide_job", default: false, null: false
    t.string "industry", default: [], array: true
    t.string "location", null: false
    t.string "requirements_description"
    t.string "responsibilities_description"
    t.string "schedule"
    t.string "work_days"
    t.uuid "employers_employer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "elevator_pitch"
    t.index ["employers_employer_id"], name: "index_employers_jobs_on_employers_employer_id"
  end

  create_table "employers_recruiters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "employers_employer_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_employers_recruiters_on_email", unique: true
    t.index ["employers_employer_id"], name: "index_employers_recruiters_on_employers_employer_id"
  end

  create_table "employers_seekers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "seeker_id", null: false
    t.string "certified_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seeker_id"], name: "index_employers_seekers_on_seeker_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "aggregate_id", null: false
    t.string "event_type", null: false
    t.jsonb "data", default: {}, null: false
    t.jsonb "metadata", default: {}, null: false
    t.integer "version", default: 0, null: false
    t.datetime "occurred_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "trace_id", null: false
    t.index ["aggregate_id"], name: "index_events_on_aggregate_id"
    t.index ["event_type", "version"], name: "index_events_on_event_type_and_version"
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["trace_id"], name: "index_events_on_trace_id"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "job_freshness_contexts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "applicants", default: {}, null: false
    t.string "employer_name", null: false
    t.string "employment_title", null: false
    t.boolean "hidden", default: false, null: false
    t.uuid "job_id", null: false
    t.boolean "recruiter_exists", default: false, null: false
    t.string "status", default: "fresh", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_freshness_employer_jobs", force: :cascade do |t|
    t.string "employer_id", null: false
    t.boolean "recruiter_exists", default: false, null: false
    t.string "jobs", default: [], null: false, array: true
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_freshnesses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "job_id"
    t.string "status"
    t.string "employment_title"
    t.string "employer_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "occurred_at", null: false
  end

  create_table "job_photos", id: :text, force: :cascade do |t|
    t.text "photo_url", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "job_tags", id: :text, force: :cascade do |t|
    t.text "job_id", null: false
    t.text "tag_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "jobs", id: :text, force: :cascade do |t|
    t.text "employer_id", null: false
    t.text "benefits_description", null: false
    t.text "responsibilities_description"
    t.text "employment_title", null: false
    t.text "location", null: false
    t.enum "employment_type", null: false, enum_type: "employment_type"
    t.boolean "hide_job", default: false, null: false
    t.text "schedule"
    t.text "work_days"
    t.text "requirements_description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.text "industry", default: [], array: true
    t.string "category", default: "marketplace"
  end

  create_table "learned_skills", id: :text, force: :cascade do |t|
    t.text "master_skill_id", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "listener_bookmarks", force: :cascade do |t|
    t.string "consumer_name", null: false
    t.uuid "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_certifications", id: :text, force: :cascade do |t|
    t.text "certification", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "master_skills", id: :text, force: :cascade do |t|
    t.text "skill", null: false
    t.enum "type", null: false, enum_type: "skill_type"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "type"
    t.string "title"
    t.string "body"
    t.string "url"
    t.text "user_id", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "onboarding_sessions", id: :text, force: :cascade do |t|
    t.text "user_id", null: false
    t.datetime "started_at", precision: 3, null: false
    t.datetime "completed_at", precision: 3
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.jsonb "responses", default: {}, null: false
    t.index ["user_id"], name: "OnboardingSession_user_id_key", unique: true
  end

  create_table "organizations", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "image"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "other_experiences", id: :text, force: :cascade do |t|
    t.text "organization_id"
    t.text "organization_name"
    t.text "start_date"
    t.boolean "is_current"
    t.text "end_date"
    t.text "description"
    t.text "position"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.uuid "seeker_id", null: false
    t.index ["seeker_id"], name: "index_other_experiences_on_seeker_id"
  end

  create_table "personal_experiences", id: :text, force: :cascade do |t|
    t.text "activity"
    t.text "start_date"
    t.text "end_date"
    t.text "description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.uuid "seeker_id", null: false
    t.index ["seeker_id"], name: "index_personal_experiences_on_seeker_id"
  end

  create_table "professional_interests", id: :text, force: :cascade do |t|
    t.text "response", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.uuid "seeker_id", null: false
    t.index ["seeker_id"], name: "index_professional_interests_on_seeker_id"
  end

  create_table "profile_certifications", id: :text, force: :cascade do |t|
    t.text "master_certification_id", null: false
    t.text "profile_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "profile_skills", id: :text, force: :cascade do |t|
    t.text "master_skill_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.uuid "seeker_id", null: false
    t.index ["seeker_id"], name: "index_profile_skills_on_seeker_id"
  end

  create_table "profiles", id: :text, force: :cascade do |t|
    t.text "user_id", null: false
    t.text "bio"
    t.text "image"
    t.text "status"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.boolean "met_career_coach", default: false
    t.index ["user_id"], name: "Profile_user_id_key", unique: true
  end

  create_table "program_skills", id: :text, force: :cascade do |t|
    t.text "program_id", null: false
    t.text "skill_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "programs", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "description", null: false
    t.text "training_provider_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "reactor_message_states", force: :cascade do |t|
    t.uuid "message_checksum", null: false
    t.string "consumer_name", null: false
    t.string "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_name", "message_checksum"], name: "reactor_message_state_index", unique: true
  end

  create_table "read_receipts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "chat_message_id", null: false
    t.text "user_id", null: false
    t.datetime "read_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_message_id"], name: "index_read_receipts_on_chat_message_id"
    t.index ["user_id"], name: "index_read_receipts_on_user_id"
  end

  create_table "reasons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recruiters", id: :text, force: :cascade do |t|
    t.text "user_id", null: false
    t.text "employer_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "roles", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["name"], name: "Role_name_key", unique: true
  end

  create_table "search_applications", force: :cascade do |t|
    t.string "status", null: false
    t.uuid "application_id", null: false
    t.uuid "seeker_id", null: false
    t.uuid "job_id", null: false
    t.text "elevator_pitch"
    t.bigint "search_job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_search_applications_on_application_id"
    t.index ["search_job_id"], name: "index_search_applications_on_search_job_id"
    t.index ["seeker_id"], name: "index_search_applications_on_seeker_id"
  end

  create_table "search_jobs", force: :cascade do |t|
    t.uuid "job_id", null: false
    t.boolean "hidden", default: false, null: false
    t.string "employment_title", null: false
    t.string "industries", default: [], array: true
    t.string "category", null: false
    t.text "location", null: false
    t.string "employment_type", null: false
    t.integer "starting_upper_pay"
    t.integer "starting_lower_pay"
    t.string "tags", default: [], array: true
    t.uuid "employer_id", null: false
    t.string "employer_name", null: false
    t.text "employer_logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employer_name"], name: "index_search_jobs_on_employer_name"
    t.index ["employment_title"], name: "index_search_jobs_on_employment_title"
    t.index ["employment_type"], name: "index_search_jobs_on_employment_type"
    t.index ["industries"], name: "index_search_jobs_on_industries"
    t.index ["job_id"], name: "index_search_jobs_on_job_id", unique: true
    t.index ["location"], name: "index_search_jobs_on_location"
    t.index ["tags"], name: "index_search_jobs_on_tags"
  end

  create_table "search_saved_jobs", force: :cascade do |t|
    t.bigint "search_job_id", null: false
    t.string "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["search_job_id"], name: "index_search_saved_jobs_on_search_job_id"
    t.index ["user_id"], name: "index_search_saved_jobs_on_user_id"
  end

  create_table "seeker_barriers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "coach_seeker_context_id", null: false
    t.uuid "barrier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barrier_id"], name: "index_seeker_barriers_on_barrier_id"
    t.index ["coach_seeker_context_id"], name: "index_seeker_barriers_on_coach_seeker_context_id"
  end

  create_table "seeker_invites", id: :text, force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "program_id", null: false
    t.text "training_provider_id", null: false
    t.datetime "used_at", precision: 3
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "seeker_notes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "coach_seeker_context_id", null: false
    t.uuid "note_id", null: false
    t.string "note", null: false
    t.datetime "note_taken_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note_taken_by"
    t.index ["coach_seeker_context_id"], name: "index_seeker_notes_on_coach_seeker_context_id"
  end

  create_table "seeker_references", id: :text, force: :cascade do |t|
    t.text "author_profile_id", null: false
    t.text "training_provider_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.text "reference_text", null: false
    t.uuid "seeker_id", null: false
    t.index ["seeker_id"], name: "index_seeker_references_on_seeker_id"
  end

  create_table "seeker_training_provider_program_statuses", id: :text, force: :cascade do |t|
    t.text "seeker_training_provider_id", null: false
    t.text "status", default: "enrolled", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "seeker_training_providers", id: :text, force: :cascade do |t|
    t.text "training_provider_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.text "program_id"
    t.text "user_id", null: false
  end

  create_table "seekers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "bio"
    t.string "image"
    t.text "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "about"
    t.index ["user_id"], name: "index_seekers_on_user_id"
  end

  create_table "sessions", id: :text, force: :cascade do |t|
    t.text "session_token", null: false
    t.text "user_id", null: false
    t.datetime "expires", precision: 3, null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["session_token"], name: "Session_session_token_key", unique: true
  end

  create_table "stories", id: :text, force: :cascade do |t|
    t.text "prompt", null: false
    t.text "response", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.uuid "seeker_id", null: false
    t.index ["seeker_id"], name: "index_stories_on_seeker_id"
  end

  create_table "tags", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "testimonials", id: :text, force: :cascade do |t|
    t.text "job_id", null: false
    t.text "name", null: false
    t.text "title", null: false
    t.text "testimonial", null: false
    t.text "photo_url"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "training_provider_invites", id: :text, force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "role_description", null: false
    t.text "training_provider_id", null: false
    t.datetime "used_at", precision: 3
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "training_provider_profiles", id: :text, force: :cascade do |t|
    t.text "training_provider_id", null: false
    t.text "user_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["user_id"], name: "TrainingProviderProfile_user_id_key", unique: true
  end

  create_table "training_providers", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "description", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "user_roles", id: :text, force: :cascade do |t|
    t.text "user_id", null: false
    t.text "role_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "users", id: :text, force: :cascade do |t|
    t.text "email"
    t.datetime "email_verified", precision: 3
    t.text "image"
    t.text "first_name"
    t.text "last_name"
    t.text "zip_code"
    t.text "phone_number"
    t.text "onboarding_session_id"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.enum "user_type", default: "SEEKER", null: false, enum_type: "user_type"
    t.string "sub", null: false
    t.index ["email"], name: "User_email_key", unique: true
    t.index ["onboarding_session_id"], name: "User_onboarding_session_id_key", unique: true
    t.index ["sub"], name: "index_users_on_sub", unique: true
  end

  create_table "verification_tokens", id: false, force: :cascade do |t|
    t.text "identifier", null: false
    t.text "token", null: false
    t.datetime "expires", precision: 3, null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["identifier", "token"], name: "VerificationToken_identifier_token_key", unique: true
    t.index ["token"], name: "VerificationToken_token_key", unique: true
  end

  create_table "webhooks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "accounts", "users", name: "Account_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "applicant_analytics", "applicants"
  add_foreign_key "applicant_analytics", "employers"
  add_foreign_key "applicant_analytics", "jobs"
  add_foreign_key "applicant_chats", "applicants"
  add_foreign_key "applicant_status_reasons", "applicant_statuses"
  add_foreign_key "applicant_status_reasons", "reasons"
  add_foreign_key "applicant_statuses", "applicants", name: "ApplicantStatus_applicant_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "applicants", "jobs", name: "Applicant_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "applicants", "seekers"
  add_foreign_key "career_paths", "jobs", name: "CareerPath_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "chat_messages", "applicant_chats"
  add_foreign_key "chat_messages", "users"
  add_foreign_key "coaches_seeker_applications", "coach_seeker_contexts"
  add_foreign_key "coaches_seeker_job_recommendations", "coach_seeker_contexts"
  add_foreign_key "coaches_seeker_job_recommendations", "coaches"
  add_foreign_key "coaches_seeker_job_recommendations", "coaches_jobs", column: "job_id"
  add_foreign_key "credentials", "organizations", name: "Credential_organization_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "desired_certifications", "jobs", name: "DesiredCertification_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "desired_certifications", "master_certifications", name: "DesiredCertification_master_certification_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "desired_skills", "jobs", name: "DesiredSkill_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "desired_skills", "master_skills", name: "DesiredSkill_master_skill_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "education_experiences", "organizations", name: "EducationExperience_organization_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "education_experiences", "seekers"
  add_foreign_key "employer_invites", "employers", name: "EmployerInvite_employer_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "employers_applicant_status_reasons", "employers_applicants"
  add_foreign_key "employers_applicants", "employers_jobs"
  add_foreign_key "employers_job_owners", "employers_jobs"
  add_foreign_key "employers_job_owners", "employers_recruiters"
  add_foreign_key "employers_jobs", "employers_employers"
  add_foreign_key "employers_recruiters", "employers_employers"
  add_foreign_key "job_photos", "jobs", name: "JobPhoto_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "job_tags", "jobs", name: "JobTag_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "job_tags", "tags", name: "JobTag_tag_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "jobs", "employers", name: "Job_employer_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "learned_skills", "jobs", name: "LearnedSkill_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "learned_skills", "master_skills", name: "LearnedSkill_master_skill_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "notifications", "users"
  add_foreign_key "onboarding_sessions", "users", name: "OnboardingSession_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "other_experiences", "organizations", name: "OtherExperience_organization_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "other_experiences", "seekers"
  add_foreign_key "personal_experiences", "seekers"
  add_foreign_key "professional_interests", "seekers"
  add_foreign_key "profile_certifications", "master_certifications", name: "ProfileCertification_master_certification_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "profile_certifications", "profiles", name: "ProfileCertification_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "profile_skills", "master_skills", name: "ProfileSkill_master_skill_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "profile_skills", "seekers"
  add_foreign_key "profiles", "users", name: "Profile_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "program_skills", "master_skills", column: "skill_id", name: "ProgramSkill_skill_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "program_skills", "programs", name: "ProgramSkill_program_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "programs", "training_providers", name: "Program_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "read_receipts", "chat_messages"
  add_foreign_key "read_receipts", "users"
  add_foreign_key "recruiters", "employers", name: "Recruiter_employer_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "recruiters", "users", name: "Recruiter_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "search_applications", "search_jobs"
  add_foreign_key "search_saved_jobs", "search_jobs"
  add_foreign_key "seeker_barriers", "barriers"
  add_foreign_key "seeker_barriers", "coach_seeker_contexts"
  add_foreign_key "seeker_invites", "programs", name: "SeekerInvite_program_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "seeker_invites", "training_providers", name: "SeekerInvite_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "seeker_notes", "coach_seeker_contexts"
  add_foreign_key "seeker_references", "seekers"
  add_foreign_key "seeker_references", "training_provider_profiles", column: "author_profile_id", name: "Reference_author_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "seeker_references", "training_providers", name: "Reference_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "seeker_training_provider_program_statuses", "seeker_training_providers", name: "seeker_training_provider_program_statuses_seeker_training__fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "seeker_training_providers", "programs", name: "SeekerTrainingProvider_program_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "seeker_training_providers", "training_providers", name: "SeekerTrainingProvider_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "seeker_training_providers", "users", name: "SeekerTrainingProvider_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "seekers", "users"
  add_foreign_key "sessions", "users", name: "Session_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "stories", "seekers"
  add_foreign_key "testimonials", "jobs", name: "Testimonial_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "training_provider_invites", "training_providers", name: "TrainingProviderInvite_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "training_provider_profiles", "training_providers", name: "TrainingProviderProfile_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "training_provider_profiles", "users", name: "TrainingProviderProfile_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "user_roles", "roles", name: "UserRoles_role_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "user_roles", "users", name: "UserRoles_user_id_fkey", on_update: :cascade, on_delete: :restrict
end
