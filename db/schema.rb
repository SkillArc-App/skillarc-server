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

ActiveRecord::Schema[7.0].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "employment_type", ["FULLTIME", "PARTTIME"]
  create_enum "skill_type", ["PERSONAL", "TECHNICAL"]
  create_enum "user_type", ["SEEKER", "TRAINING_PROVIDER"]

  create_table "Account", id: :text, force: :cascade do |t|
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

  create_table "Applicant", id: :text, force: :cascade do |t|
    t.text "job_id", null: false
    t.text "profile_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "ApplicantStatus", id: :text, force: :cascade do |t|
    t.text "applicant_id", null: false
    t.text "status", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "CareerPath", id: :text, force: :cascade do |t|
    t.text "title", null: false
    t.text "upper_limit", null: false
    t.text "lower_limit", null: false
    t.integer "order", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Credential", id: :text, force: :cascade do |t|
    t.text "organization_id"
    t.text "name"
    t.text "profile_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.text "issued_date"
  end

  create_table "DesiredCertification", id: :text, force: :cascade do |t|
    t.text "master_certification_id", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "DesiredOutcomes", id: :text, force: :cascade do |t|
    t.text "profile_id", null: false
    t.text "response", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "DesiredSkill", id: :text, force: :cascade do |t|
    t.text "master_skill_id", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "EducationExperience", id: :text, force: :cascade do |t|
    t.text "organization_id"
    t.text "organization_name"
    t.text "profile_id", null: false
    t.text "title"
    t.text "activities"
    t.text "graduation_date"
    t.text "gpa"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Employer", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "location"
    t.text "bio", null: false
    t.text "logo_url"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "EmployerInvite", id: :text, force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "employer_id", null: false
    t.datetime "used_at", precision: 3
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Job", id: :text, force: :cascade do |t|
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
    t.text "industry", array: true
  end

  create_table "JobInteraction", id: :text, force: :cascade do |t|
    t.text "job_id", null: false
    t.text "user_id", null: false
    t.boolean "has_viewed", default: false
    t.integer "percent_match"
    t.boolean "intent_to_apply", default: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "JobPhoto", id: :text, force: :cascade do |t|
    t.text "photo_url", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "JobTag", id: :text, force: :cascade do |t|
    t.text "job_id", null: false
    t.text "tag_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "LearnedSkill", id: :text, force: :cascade do |t|
    t.text "master_skill_id", null: false
    t.text "job_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "MasterCertification", id: :text, force: :cascade do |t|
    t.text "certification", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "MasterSkill", id: :text, force: :cascade do |t|
    t.text "skill", null: false
    t.enum "type", null: false, enum_type: "skill_type"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "NetworkInterests", id: :text, force: :cascade do |t|
    t.text "profile_id", null: false
    t.text "response", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "OnboardingSession", id: :text, force: :cascade do |t|
    t.text "user_id", null: false
    t.datetime "started_at", precision: 3, null: false
    t.datetime "completed_at", precision: 3
    t.text "current_step"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.jsonb "responses", default: {}, null: false
    t.index ["user_id"], name: "OnboardingSession_user_id_key", unique: true
  end

  create_table "Organization", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "image"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "OtherExperience", id: :text, force: :cascade do |t|
    t.text "organization_id"
    t.text "organization_name"
    t.text "profile_id", null: false
    t.text "start_date"
    t.boolean "is_current"
    t.text "end_date"
    t.text "description"
    t.text "position"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "PersonalExperience", id: :text, force: :cascade do |t|
    t.text "profile_id", null: false
    t.text "activity"
    t.text "start_date"
    t.text "end_date"
    t.text "description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Preference", id: :text, force: :cascade do |t|
    t.datetime "email_consent", precision: 3
    t.datetime "information_consent", precision: 3
    t.text "profile_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["profile_id"], name: "Preference_profile_id_key", unique: true
  end

  create_table "ProfessionalInterests", id: :text, force: :cascade do |t|
    t.text "profile_id", null: false
    t.text "response", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Profile", id: :text, force: :cascade do |t|
    t.text "user_id", null: false
    t.text "bio"
    t.text "image"
    t.text "status"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["user_id"], name: "Profile_user_id_key", unique: true
  end

  create_table "ProfileCertification", id: :text, force: :cascade do |t|
    t.text "master_certification_id", null: false
    t.text "profile_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "ProfileSkill", id: :text, force: :cascade do |t|
    t.text "master_skill_id", null: false
    t.text "profile_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Program", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "description", null: false
    t.text "training_provider_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "ProgramSkill", id: :text, force: :cascade do |t|
    t.text "program_id", null: false
    t.text "skill_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Recruiter", id: :text, force: :cascade do |t|
    t.text "user_id", null: false
    t.text "employer_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Reference", id: :text, force: :cascade do |t|
    t.text "author_profile_id", null: false
    t.text "seeker_profile_id", null: false
    t.text "training_provider_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.text "reference_text", null: false
  end

  create_table "Role", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["name"], name: "Role_name_key", unique: true
  end

  create_table "SeekerInvite", id: :text, force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "program_id", null: false
    t.text "training_provider_id", null: false
    t.datetime "used_at", precision: 3
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "SeekerTrainingProvider", id: :text, force: :cascade do |t|
    t.text "training_provider_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.text "program_id"
    t.text "user_id", null: false
  end

  create_table "Session", id: :text, force: :cascade do |t|
    t.text "session_token", null: false
    t.text "user_id", null: false
    t.datetime "expires", precision: 3, null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["session_token"], name: "Session_session_token_key", unique: true
  end

  create_table "Skills", id: :text, force: :cascade do |t|
    t.text "name"
    t.text "type"
    t.text "profile_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Story", id: :text, force: :cascade do |t|
    t.text "profile_id", null: false
    t.text "prompt", null: false
    t.text "response", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "Tag", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "TempUser", id: :text, force: :cascade do |t|
    t.text "name"
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
    t.index ["email"], name: "TempUser_email_key", unique: true
    t.index ["onboarding_session_id"], name: "TempUser_onboarding_session_id_key", unique: true
  end

  create_table "Testimonial", id: :text, force: :cascade do |t|
    t.text "job_id", null: false
    t.text "name", null: false
    t.text "title", null: false
    t.text "testimonial", null: false
    t.text "photo_url"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "TrainingProvider", id: :text, force: :cascade do |t|
    t.text "name", null: false
    t.text "description", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "TrainingProviderInvite", id: :text, force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "role_description", null: false
    t.text "training_provider_id", null: false
    t.datetime "used_at", precision: 3
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "TrainingProviderProfile", id: :text, force: :cascade do |t|
    t.text "training_provider_id", null: false
    t.text "user_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["user_id"], name: "TrainingProviderProfile_user_id_key", unique: true
  end

  create_table "User", id: :text, force: :cascade do |t|
    t.text "name"
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
    t.index ["email"], name: "User_email_key", unique: true
    t.index ["onboarding_session_id"], name: "User_onboarding_session_id_key", unique: true
  end

  create_table "UserRoles", id: :text, force: :cascade do |t|
    t.text "user_id", null: false
    t.text "role_id", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  create_table "VerificationToken", id: false, force: :cascade do |t|
    t.text "identifier", null: false
    t.text "token", null: false
    t.datetime "expires", precision: 3, null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.index ["identifier", "token"], name: "VerificationToken_identifier_token_key", unique: true
    t.index ["token"], name: "VerificationToken_token_key", unique: true
  end

  create_table "_prisma_migrations", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "checksum", limit: 64, null: false
    t.timestamptz "finished_at"
    t.string "migration_name", limit: 255, null: false
    t.text "logs"
    t.timestamptz "rolled_back_at"
    t.timestamptz "started_at", default: -> { "now()" }, null: false
    t.integer "applied_steps_count", default: 0, null: false
  end

  create_table "seeker_training_provider_program_statuses", id: :text, force: :cascade do |t|
    t.text "seeker_training_provider_id", null: false
    t.text "status", default: "enrolled", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, null: false
  end

  add_foreign_key "Account", "User", column: "user_id", name: "Account_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "Applicant", "Job", column: "job_id", name: "Applicant_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Applicant", "Profile", column: "profile_id", name: "Applicant_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "ApplicantStatus", "Applicant", column: "applicant_id", name: "ApplicantStatus_applicant_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "CareerPath", "Job", column: "job_id", name: "CareerPath_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Credential", "Organization", column: "organization_id", name: "Credential_organization_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "Credential", "Profile", column: "profile_id", name: "Credential_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "DesiredCertification", "Job", column: "job_id", name: "DesiredCertification_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "DesiredCertification", "MasterCertification", column: "master_certification_id", name: "DesiredCertification_master_certification_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "DesiredOutcomes", "Profile", column: "profile_id", name: "DesiredOutcomes_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "DesiredSkill", "Job", column: "job_id", name: "DesiredSkill_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "DesiredSkill", "MasterSkill", column: "master_skill_id", name: "DesiredSkill_master_skill_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "EducationExperience", "Organization", column: "organization_id", name: "EducationExperience_organization_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "EducationExperience", "Profile", column: "profile_id", name: "EducationExperience_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "EmployerInvite", "Employer", column: "employer_id", name: "EmployerInvite_employer_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Job", "Employer", column: "employer_id", name: "Job_employer_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "JobInteraction", "Job", column: "job_id", name: "JobInteraction_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "JobInteraction", "User", column: "user_id", name: "JobInteraction_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "JobPhoto", "Job", column: "job_id", name: "JobPhoto_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "JobTag", "Job", column: "job_id", name: "JobTag_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "JobTag", "Tag", column: "tag_id", name: "JobTag_tag_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "LearnedSkill", "Job", column: "job_id", name: "LearnedSkill_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "LearnedSkill", "MasterSkill", column: "master_skill_id", name: "LearnedSkill_master_skill_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "NetworkInterests", "Profile", column: "profile_id", name: "NetworkInterests_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "OnboardingSession", "User", column: "user_id", name: "OnboardingSession_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "OtherExperience", "Organization", column: "organization_id", name: "OtherExperience_organization_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "OtherExperience", "Profile", column: "profile_id", name: "OtherExperience_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "PersonalExperience", "Profile", column: "profile_id", name: "PersonalExperience_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Preference", "Profile", column: "profile_id", name: "Preference_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "ProfessionalInterests", "Profile", column: "profile_id", name: "ProfessionalInterests_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Profile", "User", column: "user_id", name: "Profile_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "ProfileCertification", "MasterCertification", column: "master_certification_id", name: "ProfileCertification_master_certification_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "ProfileCertification", "Profile", column: "profile_id", name: "ProfileCertification_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "ProfileSkill", "MasterSkill", column: "master_skill_id", name: "ProfileSkill_master_skill_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "ProfileSkill", "Profile", column: "profile_id", name: "ProfileSkill_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Program", "TrainingProvider", column: "training_provider_id", name: "Program_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "ProgramSkill", "MasterSkill", column: "skill_id", name: "ProgramSkill_skill_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "ProgramSkill", "Program", column: "program_id", name: "ProgramSkill_program_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Recruiter", "Employer", column: "employer_id", name: "Recruiter_employer_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Recruiter", "User", column: "user_id", name: "Recruiter_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Reference", "Profile", column: "seeker_profile_id", name: "Reference_seeker_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Reference", "TrainingProvider", column: "training_provider_id", name: "Reference_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Reference", "TrainingProviderProfile", column: "author_profile_id", name: "Reference_author_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "SeekerInvite", "Program", column: "program_id", name: "SeekerInvite_program_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "SeekerInvite", "TrainingProvider", column: "training_provider_id", name: "SeekerInvite_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "SeekerTrainingProvider", "Program", column: "program_id", name: "SeekerTrainingProvider_program_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "SeekerTrainingProvider", "TrainingProvider", column: "training_provider_id", name: "SeekerTrainingProvider_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "SeekerTrainingProvider", "User", column: "user_id", name: "SeekerTrainingProvider_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Session", "User", column: "user_id", name: "Session_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "Skills", "Profile", column: "profile_id", name: "Skills_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Story", "Profile", column: "profile_id", name: "Story_profile_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "Testimonial", "Job", column: "job_id", name: "Testimonial_job_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "TrainingProviderInvite", "TrainingProvider", column: "training_provider_id", name: "TrainingProviderInvite_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "TrainingProviderProfile", "TrainingProvider", column: "training_provider_id", name: "TrainingProviderProfile_training_provider_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "TrainingProviderProfile", "User", column: "user_id", name: "TrainingProviderProfile_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "UserRoles", "Role", column: "role_id", name: "UserRoles_role_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "UserRoles", "User", column: "user_id", name: "UserRoles_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "seeker_training_provider_program_statuses", "SeekerTrainingProvider", column: "seeker_training_provider_id", name: "seeker_training_provider_program_statuses_seeker_training__fkey", on_update: :cascade, on_delete: :restrict
end
