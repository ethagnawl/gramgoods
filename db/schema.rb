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

ActiveRecord::Schema.define(:version => 20130215034723) do

  create_table "address", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "_name"
    t.string  "adr1"
    t.string  "adr2"
    t.string  "city"
    t.string  "ctry"
    t.string  "post"
    t.string  "stae"
    t.string  "value"
  end

  create_table "association", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "ref"
    t.string  "rela"
    t.string  "type"
  end

  create_table "auth_group", :force => true do |t|
    t.string "name", :limit => 80, :null => false
  end

  add_index "auth_group", ["name"], :name => "auth_group_name_key", :unique => true

  create_table "auth_group_permissions", :force => true do |t|
    t.integer "group_id",      :null => false
    t.integer "permission_id", :null => false
  end

  add_index "auth_group_permissions", ["group_id", "permission_id"], :name => "auth_group_permissions_group_id_permission_id_key", :unique => true
  add_index "auth_group_permissions", ["group_id"], :name => "auth_group_permissions_group_id"
  add_index "auth_group_permissions", ["permission_id"], :name => "auth_group_permissions_permission_id"

  create_table "auth_permission", :force => true do |t|
    t.string  "name",            :limit => 50,  :null => false
    t.integer "content_type_id",                :null => false
    t.string  "codename",        :limit => 100, :null => false
  end

  add_index "auth_permission", ["content_type_id", "codename"], :name => "auth_permission_content_type_id_codename_key", :unique => true
  add_index "auth_permission", ["content_type_id"], :name => "auth_permission_content_type_id"

  create_table "auth_user", :force => true do |t|
    t.string   "username",     :limit => 30,  :null => false
    t.string   "first_name",   :limit => 30,  :null => false
    t.string   "last_name",    :limit => 30,  :null => false
    t.string   "email",        :limit => 75,  :null => false
    t.string   "password",     :limit => 128, :null => false
    t.boolean  "is_staff",                    :null => false
    t.boolean  "is_active",                   :null => false
    t.boolean  "is_superuser",                :null => false
    t.datetime "last_login",                  :null => false
    t.datetime "date_joined",                 :null => false
  end

  add_index "auth_user", ["username"], :name => "auth_user_username_key", :unique => true

  create_table "auth_user_groups", :force => true do |t|
    t.integer "user_id",  :null => false
    t.integer "group_id", :null => false
  end

  add_index "auth_user_groups", ["group_id"], :name => "auth_user_groups_group_id"
  add_index "auth_user_groups", ["user_id", "group_id"], :name => "auth_user_groups_user_id_group_id_key", :unique => true
  add_index "auth_user_groups", ["user_id"], :name => "auth_user_groups_user_id"

  create_table "auth_user_user_permissions", :force => true do |t|
    t.integer "user_id",       :null => false
    t.integer "permission_id", :null => false
  end

  add_index "auth_user_user_permissions", ["permission_id"], :name => "auth_user_user_permissions_permission_id"
  add_index "auth_user_user_permissions", ["user_id", "permission_id"], :name => "auth_user_user_permissions_user_id_permission_id_key", :unique => true
  add_index "auth_user_user_permissions", ["user_id"], :name => "auth_user_user_permissions_user_id"

  create_table "authentications", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.string   "nickname"
    t.string   "thumbnail"
  end

  create_table "celery_taskmeta", :force => true do |t|
    t.string   "task_id",                 :null => false
    t.string   "status",    :limit => 50, :null => false
    t.text     "result"
    t.datetime "date_done",               :null => false
    t.text     "traceback"
    t.boolean  "hidden",                  :null => false
    t.text     "meta"
  end

  add_index "celery_taskmeta", ["hidden"], :name => "celery_taskmeta_hidden"
  add_index "celery_taskmeta", ["task_id"], :name => "celery_taskmeta_task_id_key", :unique => true

  create_table "celery_tasksetmeta", :force => true do |t|
    t.string   "taskset_id", :null => false
    t.text     "result",     :null => false
    t.datetime "date_done",  :null => false
    t.boolean  "hidden",     :null => false
  end

  add_index "celery_tasksetmeta", ["hidden"], :name => "celery_tasksetmeta_hidden"
  add_index "celery_tasksetmeta", ["taskset_id"], :name => "celery_tasksetmeta_taskset_id_key", :unique => true

  create_table "change", :id => false, :force => true do |t|
    t.integer "persistenceid",      :limit => 8, :null => false
    t.integer "date_persistenceid", :limit => 8
  end

  create_table "characterset", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "value"
    t.string  "vers"
  end

  create_table "childref", :id => false, :force => true do |t|
    t.integer "persistenceid",       :limit => 8, :null => false
    t.integer "_frel_persistenceid", :limit => 8
    t.integer "_mrel_persistenceid", :limit => 8
  end

  create_table "colors", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "product_id"
    t.string   "color"
  end

  add_index "colors", ["product_id"], :name => "index_colors_on_product_id"

  create_table "datetime", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "time"
    t.string  "value"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "django_admin_log", :force => true do |t|
    t.datetime "action_time",                    :null => false
    t.integer  "user_id",                        :null => false
    t.integer  "content_type_id"
    t.text     "object_id"
    t.string   "object_repr",     :limit => 200, :null => false
    t.integer  "action_flag",     :limit => 2,   :null => false
    t.text     "change_message",                 :null => false
  end

  add_index "django_admin_log", ["content_type_id"], :name => "django_admin_log_content_type_id"
  add_index "django_admin_log", ["user_id"], :name => "django_admin_log_user_id"

  create_table "django_comment_flags", :force => true do |t|
    t.integer  "user_id",                  :null => false
    t.integer  "comment_id",               :null => false
    t.string   "flag",       :limit => 30, :null => false
    t.datetime "flag_date",                :null => false
  end

  add_index "django_comment_flags", ["comment_id"], :name => "django_comment_flags_comment_id"
  add_index "django_comment_flags", ["flag"], :name => "django_comment_flags_flag"
  add_index "django_comment_flags", ["flag"], :name => "django_comment_flags_flag_like"
  add_index "django_comment_flags", ["user_id", "comment_id", "flag"], :name => "django_comment_flags_user_id_comment_id_flag_key", :unique => true
  add_index "django_comment_flags", ["user_id"], :name => "django_comment_flags_user_id"

  create_table "django_comments", :force => true do |t|
    t.integer  "content_type_id",                :null => false
    t.text     "object_pk",                      :null => false
    t.integer  "site_id",                        :null => false
    t.integer  "user_id"
    t.string   "user_name",       :limit => 50,  :null => false
    t.string   "user_email",      :limit => 75,  :null => false
    t.string   "user_url",        :limit => 200, :null => false
    t.text     "comment",                        :null => false
    t.datetime "submit_date",                    :null => false
    t.string   "ip_address"
    t.boolean  "is_public",                      :null => false
    t.boolean  "is_removed",                     :null => false
  end

  add_index "django_comments", ["content_type_id"], :name => "django_comments_content_type_id"
  add_index "django_comments", ["site_id"], :name => "django_comments_site_id"
  add_index "django_comments", ["user_id"], :name => "django_comments_user_id"

  create_table "django_content_type", :force => true do |t|
    t.string "name",      :limit => 100, :null => false
    t.string "app_label", :limit => 100, :null => false
    t.string "model",     :limit => 100, :null => false
  end

  add_index "django_content_type", ["app_label", "model"], :name => "django_content_type_app_label_model_key", :unique => true

  create_table "django_flatpage", :force => true do |t|
    t.string  "url",                   :limit => 100, :null => false
    t.string  "title",                 :limit => 200, :null => false
    t.text    "content",                              :null => false
    t.boolean "enable_comments",                      :null => false
    t.string  "template_name",         :limit => 70,  :null => false
    t.boolean "registration_required",                :null => false
  end

  add_index "django_flatpage", ["url"], :name => "django_flatpage_url"
  add_index "django_flatpage", ["url"], :name => "django_flatpage_url_like"

  create_table "django_flatpage_sites", :force => true do |t|
    t.integer "flatpage_id", :null => false
    t.integer "site_id",     :null => false
  end

  add_index "django_flatpage_sites", ["flatpage_id", "site_id"], :name => "django_flatpage_sites_flatpage_id_site_id_key", :unique => true
  add_index "django_flatpage_sites", ["flatpage_id"], :name => "django_flatpage_sites_flatpage_id"
  add_index "django_flatpage_sites", ["site_id"], :name => "django_flatpage_sites_site_id"

  create_table "django_session", :id => false, :force => true do |t|
    t.string   "session_key",  :limit => 40, :null => false
    t.text     "session_data",               :null => false
    t.datetime "expire_date",                :null => false
  end

  add_index "django_session", ["expire_date"], :name => "django_session_expire_date"

  create_table "django_site", :force => true do |t|
    t.string "domain", :limit => 100, :null => false
    t.string "name",   :limit => 50,  :null => false
  end

  create_table "djcelery_crontabschedule", :force => true do |t|
    t.string "minute",        :limit => 64, :null => false
    t.string "hour",          :limit => 64, :null => false
    t.string "day_of_week",   :limit => 64, :null => false
    t.string "day_of_month",  :limit => 64, :null => false
    t.string "month_of_year", :limit => 64, :null => false
  end

  create_table "djcelery_intervalschedule", :force => true do |t|
    t.integer "every",                :null => false
    t.string  "period", :limit => 24, :null => false
  end

  create_table "djcelery_periodictask", :force => true do |t|
    t.string   "name",            :limit => 200, :null => false
    t.string   "task",            :limit => 200, :null => false
    t.integer  "interval_id"
    t.integer  "crontab_id"
    t.text     "args",                           :null => false
    t.text     "kwargs",                         :null => false
    t.string   "queue",           :limit => 200
    t.string   "exchange",        :limit => 200
    t.string   "routing_key",     :limit => 200
    t.datetime "expires"
    t.boolean  "enabled",                        :null => false
    t.datetime "last_run_at"
    t.integer  "total_run_count",                :null => false
    t.datetime "date_changed",                   :null => false
    t.text     "description",                    :null => false
  end

  add_index "djcelery_periodictask", ["crontab_id"], :name => "djcelery_periodictask_crontab_id"
  add_index "djcelery_periodictask", ["interval_id"], :name => "djcelery_periodictask_interval_id"
  add_index "djcelery_periodictask", ["name"], :name => "djcelery_periodictask_name_key", :unique => true

  create_table "djcelery_periodictasks", :id => false, :force => true do |t|
    t.integer  "ident",       :limit => 2, :null => false
    t.datetime "last_update",              :null => false
  end

  create_table "djcelery_taskstate", :force => true do |t|
    t.string   "state",     :limit => 64,  :null => false
    t.string   "task_id",   :limit => 36,  :null => false
    t.string   "name",      :limit => 200
    t.datetime "tstamp",                   :null => false
    t.text     "args"
    t.text     "kwargs"
    t.datetime "eta"
    t.datetime "expires"
    t.text     "result"
    t.text     "traceback"
    t.float    "runtime"
    t.integer  "retries",                  :null => false
    t.integer  "worker_id"
    t.boolean  "hidden",                   :null => false
  end

  add_index "djcelery_taskstate", ["hidden"], :name => "djcelery_taskstate_hidden"
  add_index "djcelery_taskstate", ["name"], :name => "djcelery_taskstate_name"
  add_index "djcelery_taskstate", ["name"], :name => "djcelery_taskstate_name_like"
  add_index "djcelery_taskstate", ["state"], :name => "djcelery_taskstate_state"
  add_index "djcelery_taskstate", ["state"], :name => "djcelery_taskstate_state_like"
  add_index "djcelery_taskstate", ["task_id"], :name => "djcelery_taskstate_task_id_key", :unique => true
  add_index "djcelery_taskstate", ["tstamp"], :name => "djcelery_taskstate_tstamp"
  add_index "djcelery_taskstate", ["worker_id"], :name => "djcelery_taskstate_worker_id"

  create_table "djcelery_workerstate", :force => true do |t|
    t.string   "hostname",       :null => false
    t.datetime "last_heartbeat"
  end

  add_index "djcelery_workerstate", ["hostname"], :name => "djcelery_workerstate_hostname_key", :unique => true
  add_index "djcelery_workerstate", ["last_heartbeat"], :name => "djcelery_workerstate_last_heartbeat"

  create_table "djkombu_message", :force => true do |t|
    t.boolean  "visible",  :null => false
    t.datetime "sent_at"
    t.text     "payload",  :null => false
    t.integer  "queue_id", :null => false
  end

  add_index "djkombu_message", ["queue_id"], :name => "djkombu_message_queue_id"
  add_index "djkombu_message", ["sent_at"], :name => "djkombu_message_sent_at"
  add_index "djkombu_message", ["visible"], :name => "djkombu_message_visible"

  create_table "djkombu_queue", :force => true do |t|
    t.string "name", :limit => 200, :null => false
  end

  add_index "djkombu_queue", ["name"], :name => "djkombu_queue_name_key", :unique => true

  create_table "eventfact", :primary_key => "persistenceid", :force => true do |t|
    t.string  "dtype",                :limit => 31, :null => false
    t.string  "_uid"
    t.string  "date"
    t.string  "place"
    t.string  "rin"
    t.string  "tag"
    t.string  "type"
    t.string  "uidtag"
    t.string  "value"
    t.string  "stat"
    t.string  "temp"
    t.integer "gedcom_persistenceid", :limit => 8
    t.integer "addr_persistenceid",   :limit => 8
    t.integer "caus_persistenceid",   :limit => 8
    t.integer "family_persistenceid", :limit => 8
    t.integer "person_persistenceid", :limit => 8
    t.integer "place_match_id"
  end

  add_index "eventfact", ["family_persistenceid", "tag"], :name => "eventfact_family_persistenceid_tag_idx"
  add_index "eventfact", ["family_persistenceid"], :name => "eventfact_family_persistenceid"
  add_index "eventfact", ["gedcom_persistenceid"], :name => "eventfact_gedcom_persistenceid"
  add_index "eventfact", ["person_persistenceid", "tag"], :name => "eventfact_person_persistenceid_tag_idx"
  add_index "eventfact", ["person_persistenceid"], :name => "eventfact_person_persistenceid"
  add_index "eventfact", ["place_match_id"], :name => "eventfact_place_match_id"

  create_table "eventfact_media", :id => false, :force => true do |t|
    t.integer "eventfact_persistenceid", :limit => 8, :null => false
    t.integer "media_persistenceid",     :limit => 8, :null => false
  end

  add_index "eventfact_media", ["media_persistenceid"], :name => "eventfact_media_media_persistenceid_key", :unique => true

  create_table "eventfact_mediaref", :id => false, :force => true do |t|
    t.integer "eventfact_persistenceid", :limit => 8, :null => false
    t.integer "mediarefs_persistenceid", :limit => 8, :null => false
  end

  add_index "eventfact_mediaref", ["mediarefs_persistenceid"], :name => "eventfact_mediaref_mediarefs_persistenceid_key", :unique => true

  create_table "eventfact_note", :id => false, :force => true do |t|
    t.integer "eventfact_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid",     :limit => 8, :null => false
  end

  add_index "eventfact_note", ["notes_persistenceid"], :name => "eventfact_note_notes_persistenceid_key", :unique => true

  create_table "eventfact_noteref", :id => false, :force => true do |t|
    t.integer "eventfact_persistenceid", :limit => 8, :null => false
    t.integer "noterefs_persistenceid",  :limit => 8, :null => false
  end

  add_index "eventfact_noteref", ["noterefs_persistenceid"], :name => "eventfact_noteref_noterefs_persistenceid_key", :unique => true

  create_table "eventfact_sourcecitation", :id => false, :force => true do |t|
    t.integer "eventfact_persistenceid",       :limit => 8, :null => false
    t.integer "sourcecitations_persistenceid", :limit => 8, :null => false
  end

  add_index "eventfact_sourcecitation", ["sourcecitations_persistenceid"], :name => "eventfact_sourcecitation_sourcecitations_persistenceid_key", :unique => true

  create_table "family", :primary_key => "persistenceid", :force => true do |t|
    t.string  "_uid"
    t.string  "rin"
    t.string  "uidtag"
    t.string  "id"
    t.integer "gedcom_persistenceid", :limit => 8
    t.integer "chan_persistenceid",   :limit => 8
  end

  add_index "family", ["gedcom_persistenceid"], :name => "family_gedcom_persistenceid"

  create_table "family_childrefs", :id => false, :force => true do |t|
    t.integer "family_persistenceid",    :limit => 8, :null => false
    t.integer "childrefs_persistenceid", :limit => 8, :null => false
  end

  create_table "family_eventfact", :id => false, :force => true do |t|
    t.integer "family_persistenceid",      :limit => 8, :null => false
    t.integer "eventsfacts_persistenceid", :limit => 8, :null => false
  end

  create_table "family_husbandrefs", :id => false, :force => true do |t|
    t.integer "family_persistenceid",      :limit => 8, :null => false
    t.integer "husbandrefs_persistenceid", :limit => 8, :null => false
  end

  create_table "family_media", :id => false, :force => true do |t|
    t.integer "family_persistenceid", :limit => 8, :null => false
    t.integer "media_persistenceid",  :limit => 8, :null => false
  end

  add_index "family_media", ["media_persistenceid"], :name => "family_media_media_persistenceid_key", :unique => true

  create_table "family_mediaref", :id => false, :force => true do |t|
    t.integer "family_persistenceid",    :limit => 8, :null => false
    t.integer "mediarefs_persistenceid", :limit => 8, :null => false
  end

  add_index "family_mediaref", ["mediarefs_persistenceid"], :name => "family_mediaref_mediarefs_persistenceid_key", :unique => true

  create_table "family_note", :id => false, :force => true do |t|
    t.integer "family_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid",  :limit => 8, :null => false
  end

  add_index "family_note", ["notes_persistenceid"], :name => "family_note_notes_persistenceid_key", :unique => true

  create_table "family_noteref", :id => false, :force => true do |t|
    t.integer "family_persistenceid",   :limit => 8, :null => false
    t.integer "noterefs_persistenceid", :limit => 8, :null => false
  end

  add_index "family_noteref", ["noterefs_persistenceid"], :name => "family_noteref_noterefs_persistenceid_key", :unique => true

  create_table "family_person", :primary_key => "persistenceid", :force => true do |t|
    t.string  "_pref"
    t.integer "family_persistenceid",          :limit => 8, :null => false
    t.string  "fatherparentrelationshipvalue"
    t.string  "motherparentrelationshipvalue"
    t.integer "person_persistenceid",          :limit => 8, :null => false
    t.string  "roleinfamily",                  :limit => 1, :null => false
  end

  add_index "family_person", ["family_persistenceid", "roleinfamily"], :name => "family_person_family_persistenceid_roleinfamily_idx"
  add_index "family_person", ["family_persistenceid"], :name => "family_person_family_persistenceid"
  add_index "family_person", ["person_persistenceid", "roleinfamily"], :name => "family_person_person_persistenceid_roleinfamily_idx"
  add_index "family_person", ["person_persistenceid"], :name => "family_person_person_persistenceid"

  create_table "family_sourcecitation", :id => false, :force => true do |t|
    t.integer "family_persistenceid",          :limit => 8, :null => false
    t.integer "sourcecitations_persistenceid", :limit => 8, :null => false
  end

  add_index "family_sourcecitation", ["sourcecitations_persistenceid"], :name => "family_sourcecitation_sourcecitations_persistenceid_key", :unique => true

  create_table "family_wiferefs", :id => false, :force => true do |t|
    t.integer "family_persistenceid",   :limit => 8, :null => false
    t.integer "wiferefs_persistenceid", :limit => 8, :null => false
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "gedcom", :primary_key => "persistenceid", :force => true do |t|
    t.integer  "jobid",                         :limit => 8
    t.text     "parsererrors"
    t.text     "parserwarnings"
    t.integer  "status",                                     :null => false
    t.integer  "uid",                           :limit => 8, :null => false
    t.integer  "head_persistenceid",            :limit => 8
    t.integer  "subm_persistenceid",            :limit => 8
    t.integer  "subn_persistenceid",            :limit => 8
    t.string   "name"
    t.datetime "date_uploaded"
    t.datetime "start_time"
    t.integer  "first_gedperson_persistenceid", :limit => 8
  end

  add_index "gedcom", ["first_gedperson_persistenceid"], :name => "gedcom_first_gedperson_persistenceid"
  add_index "gedcom", ["uid"], :name => "gedcom_uid"

  create_table "gedcomversion", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "form"
    t.string  "vers"
  end

  create_table "generator", :id => false, :force => true do |t|
    t.integer "persistenceid",      :limit => 8, :null => false
    t.string  "name"
    t.string  "value"
    t.string  "vers"
    t.integer "corp_persistenceid", :limit => 8
    t.integer "data_persistenceid", :limit => 8
  end

  create_table "generatorcorporation", :id => false, :force => true do |t|
    t.integer "persistenceid",      :limit => 8, :null => false
    t.string  "_www"
    t.string  "phon"
    t.string  "value"
    t.string  "wwwtag"
    t.integer "addr_persistenceid", :limit => 8
  end

  create_table "generatordata", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "copr"
    t.string  "date"
    t.string  "value"
  end

  create_table "header", :id => false, :force => true do |t|
    t.integer "persistenceid",         :limit => 8, :null => false
    t.string  "copr"
    t.string  "dest"
    t.string  "file"
    t.string  "lang"
    t.string  "submref"
    t.string  "subnref"
    t.integer "gedcom_persistenceid",  :limit => 8
    t.integer "charset_persistenceid", :limit => 8
    t.integer "date_persistenceid",    :limit => 8
    t.integer "gedc_persistenceid",    :limit => 8
    t.integer "sour_persistenceid",    :limit => 8
    t.integer "subm_persistenceid",    :limit => 8
    t.integer "subn_persistenceid",    :limit => 8
  end

  create_table "header_note", :id => false, :force => true do |t|
    t.integer "header_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid",  :limit => 8, :null => false
  end

  add_index "header_note", ["notes_persistenceid"], :name => "header_note_notes_persistenceid_key", :unique => true

  create_table "header_noteref", :id => false, :force => true do |t|
    t.integer "header_persistenceid",   :limit => 8, :null => false
    t.integer "noterefs_persistenceid", :limit => 8, :null => false
  end

  add_index "header_noteref", ["noterefs_persistenceid"], :name => "header_noteref_noterefs_persistenceid_key", :unique => true

  create_table "instagram_product_images", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "url"
  end

  create_table "line_items", :force => true do |t|
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "size"
    t.string   "color"
    t.decimal  "price",                                :precision => 10, :scale => 2
    t.decimal  "total"
    t.decimal  "flatrate_shipping_option_cost",        :precision => 10, :scale => 2
    t.string   "product_name"
    t.decimal  "international_flatrate_shipping_cost"
    t.string   "flatrate_shipping_option"
  end

  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"

  create_table "media", :id => false, :force => true do |t|
    t.integer "persistenceid",        :limit => 8, :null => false
    t.string  "_file"
    t.string  "_prim"
    t.string  "_scbk"
    t.string  "_sshow"
    t.string  "_type"
    t.string  "blob"
    t.string  "filetag"
    t.string  "form"
    t.string  "id"
    t.string  "titl"
    t.integer "gedcom_persistenceid", :limit => 8
    t.integer "chan_persistenceid",   :limit => 8
  end

  create_table "media_note", :id => false, :force => true do |t|
    t.integer "media_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid", :limit => 8, :null => false
  end

  add_index "media_note", ["notes_persistenceid"], :name => "media_note_notes_persistenceid_key", :unique => true

  create_table "media_noteref", :id => false, :force => true do |t|
    t.integer "media_persistenceid",    :limit => 8, :null => false
    t.integer "noterefs_persistenceid", :limit => 8, :null => false
  end

  add_index "media_noteref", ["noterefs_persistenceid"], :name => "media_noteref_noterefs_persistenceid_key", :unique => true

  create_table "mediaref", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "ref"
  end

  create_table "name", :primary_key => "persistenceid", :force => true do |t|
    t.string  "_aka"
    t.string  "_marrnm"
    t.string  "_type"
    t.string  "akatag"
    t.string  "givn"
    t.string  "marrnmtag"
    t.string  "nick"
    t.string  "npfx"
    t.string  "nsfx"
    t.string  "spfx"
    t.string  "surn"
    t.string  "typetag"
    t.string  "value"
    t.integer "gedcom_persistenceid", :limit => 8
    t.integer "person_persistenceid", :limit => 8
  end

  add_index "name", ["person_persistenceid"], :name => "name_person_persistenceid"

  create_table "name_media", :id => false, :force => true do |t|
    t.integer "name_persistenceid",  :limit => 8, :null => false
    t.integer "media_persistenceid", :limit => 8, :null => false
  end

  add_index "name_media", ["media_persistenceid"], :name => "name_media_media_persistenceid_key", :unique => true

  create_table "name_mediaref", :id => false, :force => true do |t|
    t.integer "name_persistenceid",      :limit => 8, :null => false
    t.integer "mediarefs_persistenceid", :limit => 8, :null => false
  end

  add_index "name_mediaref", ["mediarefs_persistenceid"], :name => "name_mediaref_mediarefs_persistenceid_key", :unique => true

  create_table "name_note", :id => false, :force => true do |t|
    t.integer "name_persistenceid",  :limit => 8, :null => false
    t.integer "notes_persistenceid", :limit => 8, :null => false
  end

  add_index "name_note", ["notes_persistenceid"], :name => "name_note_notes_persistenceid_key", :unique => true

  create_table "name_noteref", :id => false, :force => true do |t|
    t.integer "name_persistenceid",     :limit => 8, :null => false
    t.integer "noterefs_persistenceid", :limit => 8, :null => false
  end

  add_index "name_noteref", ["noterefs_persistenceid"], :name => "name_noteref_noterefs_persistenceid_key", :unique => true

  create_table "name_sourcecitation", :id => false, :force => true do |t|
    t.integer "name_persistenceid",            :limit => 8, :null => false
    t.integer "sourcecitations_persistenceid", :limit => 8, :null => false
  end

  add_index "name_sourcecitation", ["sourcecitations_persistenceid"], :name => "name_sourcecitation_sourcecitations_persistenceid_key", :unique => true

  create_table "note", :id => false, :force => true do |t|
    t.integer "persistenceid",             :limit => 8, :null => false
    t.string  "id"
    t.string  "rin"
    t.boolean "sourcecitationsundervalue",              :null => false
    t.text    "value"
    t.integer "chan_persistenceid",        :limit => 8
    t.integer "gedcom_persistenceid",      :limit => 8
  end

  create_table "note_sourcecitation", :id => false, :force => true do |t|
    t.integer "note_persistenceid",            :limit => 8, :null => false
    t.integer "sourcecitations_persistenceid", :limit => 8, :null => false
  end

  add_index "note_sourcecitation", ["sourcecitations_persistenceid"], :name => "note_sourcecitation_sourcecitations_persistenceid_key", :unique => true

  create_table "noteref", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "ref"
  end

  create_table "noteref_sourcecitation", :id => false, :force => true do |t|
    t.integer "noteref_persistenceid",         :limit => 8, :null => false
    t.integer "sourcecitations_persistenceid", :limit => 8, :null => false
  end

  add_index "noteref_sourcecitation", ["sourcecitations_persistenceid"], :name => "noteref_sourcecitation_sourcecitations_persistenceid_key", :unique => true

  create_table "orders", :force => true do |t|
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "store_id"
    t.string   "status",     :default => "pending"
    t.string   "access_key"
  end

  add_index "orders", ["store_id"], :name => "index_orders_on_store_id"

  create_table "parentfamilyref", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "_primary"
    t.string  "pedi"
  end

  create_table "parentrelationship", :id => false, :force => true do |t|
    t.integer "persistenceid",        :limit => 8, :null => false
    t.string  "value"
    t.integer "gedcom_persistenceid", :limit => 8
  end

  create_table "parentrelationship_media", :id => false, :force => true do |t|
    t.integer "parentrelationship_persistenceid", :limit => 8, :null => false
    t.integer "media_persistenceid",              :limit => 8, :null => false
  end

  add_index "parentrelationship_media", ["media_persistenceid"], :name => "parentrelationship_media_media_persistenceid_key", :unique => true

  create_table "parentrelationship_mediaref", :id => false, :force => true do |t|
    t.integer "parentrelationship_persistenceid", :limit => 8, :null => false
    t.integer "mediarefs_persistenceid",          :limit => 8, :null => false
  end

  add_index "parentrelationship_mediaref", ["mediarefs_persistenceid"], :name => "parentrelationship_mediaref_mediarefs_persistenceid_key", :unique => true

  create_table "parentrelationship_note", :id => false, :force => true do |t|
    t.integer "parentrelationship_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid",              :limit => 8, :null => false
  end

  add_index "parentrelationship_note", ["notes_persistenceid"], :name => "parentrelationship_note_notes_persistenceid_key", :unique => true

  create_table "parentrelationship_noteref", :id => false, :force => true do |t|
    t.integer "parentrelationship_persistenceid", :limit => 8, :null => false
    t.integer "noterefs_persistenceid",           :limit => 8, :null => false
  end

  add_index "parentrelationship_noteref", ["noterefs_persistenceid"], :name => "parentrelationship_noteref_noterefs_persistenceid_key", :unique => true

  create_table "parentrelationship_sourcecitation", :id => false, :force => true do |t|
    t.integer "parentrelationship_persistenceid", :limit => 8, :null => false
    t.integer "sourcecitations_persistenceid",    :limit => 8, :null => false
  end

  add_index "parentrelationship_sourcecitation", ["sourcecitations_persistenceid"], :name => "parentrelationship_sourcecita_sourcecitations_persistenceid_key", :unique => true

  create_table "person", :primary_key => "persistenceid", :force => true do |t|
    t.string  "_uid"
    t.string  "rin"
    t.string  "uidtag"
    t.string  "anci"
    t.string  "desi"
    t.string  "email"
    t.string  "emailtag"
    t.string  "id"
    t.string  "phon"
    t.string  "rfn"
    t.integer "gedcom_persistenceid", :limit => 8
    t.integer "chan_persistenceid",   :limit => 8
    t.integer "addr_persistenceid",   :limit => 8
  end

  add_index "person", ["gedcom_persistenceid"], :name => "person_gedcom_persistenceid"

  create_table "person_association", :id => false, :force => true do |t|
    t.integer "person_persistenceid", :limit => 8, :null => false
    t.integer "assos_persistenceid",  :limit => 8, :null => false
  end

  create_table "person_eventfact", :id => false, :force => true do |t|
    t.integer "person_persistenceid",      :limit => 8, :null => false
    t.integer "eventsfacts_persistenceid", :limit => 8, :null => false
  end

  create_table "person_media", :id => false, :force => true do |t|
    t.integer "person_persistenceid", :limit => 8, :null => false
    t.integer "media_persistenceid",  :limit => 8, :null => false
  end

  add_index "person_media", ["media_persistenceid"], :name => "person_media_media_persistenceid_key", :unique => true

  create_table "person_mediaref", :id => false, :force => true do |t|
    t.integer "person_persistenceid",    :limit => 8, :null => false
    t.integer "mediarefs_persistenceid", :limit => 8, :null => false
  end

  add_index "person_mediaref", ["mediarefs_persistenceid"], :name => "person_mediaref_mediarefs_persistenceid_key", :unique => true

  create_table "person_note", :id => false, :force => true do |t|
    t.integer "person_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid",  :limit => 8, :null => false
  end

  add_index "person_note", ["notes_persistenceid"], :name => "person_note_notes_persistenceid_key", :unique => true

  create_table "person_noteref", :id => false, :force => true do |t|
    t.integer "person_persistenceid",   :limit => 8, :null => false
    t.integer "noterefs_persistenceid", :limit => 8, :null => false
  end

  add_index "person_noteref", ["noterefs_persistenceid"], :name => "person_noteref_noterefs_persistenceid_key", :unique => true

  create_table "person_parentfamilyref", :id => false, :force => true do |t|
    t.integer "person_persistenceid", :limit => 8, :null => false
    t.integer "famc_persistenceid",   :limit => 8, :null => false
  end

  create_table "person_sourcecitation", :id => false, :force => true do |t|
    t.integer "person_persistenceid",          :limit => 8, :null => false
    t.integer "sourcecitations_persistenceid", :limit => 8, :null => false
  end

  add_index "person_sourcecitation", ["sourcecitations_persistenceid"], :name => "person_sourcecitation_sourcecitations_persistenceid_key", :unique => true

  create_table "person_spousefamilyref", :id => false, :force => true do |t|
    t.integer "person_persistenceid", :limit => 8, :null => false
    t.integer "fams_persistenceid",   :limit => 8, :null => false
  end

  create_table "pfcc_ldsordinance", :id => false, :force => true do |t|
    t.integer "person_persistenceid",        :limit => 8, :null => false
    t.integer "ldsordinances_persistenceid", :limit => 8, :null => false
    t.integer "family_persistenceid",        :limit => 8, :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.decimal  "price",                                :precision => 10, :scale => 2
    t.decimal  "domestic_flatrate_shipping_cost",      :precision => 10, :scale => 2
    t.integer  "quantity"
    t.integer  "store_id"
    t.string   "slug"
    t.boolean  "unlimited_quantity"
    t.datetime "updated_at",                                                                                 :null => false
    t.datetime "created_at",                                                                                 :null => false
    t.text     "product_images"
    t.decimal  "international_flatrate_shipping_cost"
    t.string   "purchase_type",                                                       :default => "buy-now"
    t.boolean  "external",                                                            :default => false
    t.string   "external_url"
    t.integer  "external_clickthroughs",                                              :default => 0
  end

  add_index "products", ["slug"], :name => "index_products_on_slug"
  add_index "products", ["store_id"], :name => "index_products_on_store_id"

  create_table "recipients", :force => true do |t|
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "order_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "street_address_one"
    t.string   "street_address_two"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country",            :default => "United States"
  end

  add_index "recipients", ["order_id"], :name => "index_recipients_on_order_id"

  create_table "repository", :id => false, :force => true do |t|
    t.integer "persistenceid",        :limit => 8, :null => false
    t.string  "_email"
    t.string  "_www"
    t.string  "emailtag"
    t.string  "id"
    t.string  "name"
    t.string  "phon"
    t.string  "rin"
    t.string  "value"
    t.string  "wwwtag"
    t.integer "gedcom_persistenceid", :limit => 8
    t.integer "addr_persistenceid",   :limit => 8
    t.integer "chan_persistenceid",   :limit => 8
  end

  create_table "repository_note", :id => false, :force => true do |t|
    t.integer "repository_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid",      :limit => 8, :null => false
  end

  add_index "repository_note", ["notes_persistenceid"], :name => "repository_note_notes_persistenceid_key", :unique => true

  create_table "repository_noteref", :id => false, :force => true do |t|
    t.integer "repository_persistenceid", :limit => 8, :null => false
    t.integer "noterefs_persistenceid",   :limit => 8, :null => false
  end

  add_index "repository_noteref", ["noterefs_persistenceid"], :name => "repository_noteref_noterefs_persistenceid_key", :unique => true

  create_table "repositoryref", :id => false, :force => true do |t|
    t.integer "persistenceid",        :limit => 8, :null => false
    t.string  "caln"
    t.string  "ismediundercalntag"
    t.string  "medi"
    t.string  "ref"
    t.string  "value"
    t.integer "gedcom_persistenceid", :limit => 8
  end

  create_table "repositoryref_note", :id => false, :force => true do |t|
    t.integer "repositoryref_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid",         :limit => 8, :null => false
  end

  add_index "repositoryref_note", ["notes_persistenceid"], :name => "repositoryref_note_notes_persistenceid_key", :unique => true

  create_table "repositoryref_noteref", :id => false, :force => true do |t|
    t.integer "repositoryref_persistenceid", :limit => 8, :null => false
    t.integer "noterefs_persistenceid",      :limit => 8, :null => false
  end

  add_index "repositoryref_noteref", ["noterefs_persistenceid"], :name => "repositoryref_noteref_noterefs_persistenceid_key", :unique => true

  create_table "sizes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "product_id"
    t.string   "size"
  end

  add_index "sizes", ["product_id"], :name => "index_sizes_on_product_id"

  create_table "source", :id => false, :force => true do |t|
    t.integer "persistenceid",        :limit => 8, :null => false
    t.string  "_italic"
    t.string  "_paren"
    t.string  "_type"
    t.string  "_uid"
    t.string  "abbr"
    t.string  "auth"
    t.string  "caln"
    t.string  "date"
    t.string  "id"
    t.string  "medi"
    t.string  "publ"
    t.string  "refn"
    t.string  "rin"
    t.string  "text"
    t.string  "titl"
    t.string  "typetag"
    t.string  "uidtag"
    t.integer "gedcom_persistenceid", :limit => 8
    t.integer "chan_persistenceid",   :limit => 8
    t.integer "repo_persistenceid",   :limit => 8
  end

  add_index "source", ["gedcom_persistenceid"], :name => "source_gedcom_persistenceid"

  create_table "source_media", :id => false, :force => true do |t|
    t.integer "source_persistenceid", :limit => 8, :null => false
    t.integer "media_persistenceid",  :limit => 8, :null => false
  end

  add_index "source_media", ["media_persistenceid"], :name => "source_media_media_persistenceid_key", :unique => true

  create_table "source_mediaref", :id => false, :force => true do |t|
    t.integer "source_persistenceid",    :limit => 8, :null => false
    t.integer "mediarefs_persistenceid", :limit => 8, :null => false
  end

  add_index "source_mediaref", ["mediarefs_persistenceid"], :name => "source_mediaref_mediarefs_persistenceid_key", :unique => true

  create_table "source_note", :id => false, :force => true do |t|
    t.integer "source_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid",  :limit => 8, :null => false
  end

  add_index "source_note", ["notes_persistenceid"], :name => "source_note_notes_persistenceid_key", :unique => true

  create_table "source_noteref", :id => false, :force => true do |t|
    t.integer "source_persistenceid",   :limit => 8, :null => false
    t.integer "noterefs_persistenceid", :limit => 8, :null => false
  end

  add_index "source_noteref", ["noterefs_persistenceid"], :name => "source_noteref_noterefs_persistenceid_key", :unique => true

  create_table "sourcecitation", :id => false, :force => true do |t|
    t.integer "persistenceid",           :limit => 8, :null => false
    t.integer "datatagcontents"
    t.string  "date"
    t.string  "page"
    t.string  "quay"
    t.string  "ref"
    t.string  "text"
    t.string  "value"
    t.integer "gedcom_persistenceid",    :limit => 8
    t.integer "eventfact_persistenceid", :limit => 8
    t.integer "source_persistenceid",    :limit => 8
  end

  add_index "sourcecitation", ["eventfact_persistenceid"], :name => "sourcecitation_eventfact_persistenceid"
  add_index "sourcecitation", ["source_persistenceid"], :name => "sourcecitation_source_persistenceid"

  create_table "sourcecitation_media", :id => false, :force => true do |t|
    t.integer "sourcecitation_persistenceid", :limit => 8, :null => false
    t.integer "media_persistenceid",          :limit => 8, :null => false
  end

  add_index "sourcecitation_media", ["media_persistenceid"], :name => "sourcecitation_media_media_persistenceid_key", :unique => true

  create_table "sourcecitation_mediaref", :id => false, :force => true do |t|
    t.integer "sourcecitation_persistenceid", :limit => 8, :null => false
    t.integer "mediarefs_persistenceid",      :limit => 8, :null => false
  end

  add_index "sourcecitation_mediaref", ["mediarefs_persistenceid"], :name => "sourcecitation_mediaref_mediarefs_persistenceid_key", :unique => true

  create_table "sourcecitation_note", :id => false, :force => true do |t|
    t.integer "sourcecitation_persistenceid", :limit => 8, :null => false
    t.integer "notes_persistenceid",          :limit => 8, :null => false
  end

  add_index "sourcecitation_note", ["notes_persistenceid"], :name => "sourcecitation_note_notes_persistenceid_key", :unique => true

  create_table "sourcecitation_noteref", :id => false, :force => true do |t|
    t.integer "sourcecitation_persistenceid", :limit => 8, :null => false
    t.integer "noterefs_persistenceid",       :limit => 8, :null => false
  end

  add_index "sourcecitation_noteref", ["noterefs_persistenceid"], :name => "sourcecitation_noteref_noterefs_persistenceid_key", :unique => true

  create_table "south_migrationhistory", :force => true do |t|
    t.string   "app_name",  :null => false
    t.string   "migration", :null => false
    t.datetime "applied",   :null => false
  end

  create_table "spousefamilyref", :id => false, :force => true do |t|
    t.string  "dtype",         :limit => 31, :null => false
    t.integer "persistenceid", :limit => 8,  :null => false
    t.string  "ref"
    t.string  "_primary"
    t.string  "pedi"
  end

  create_table "spouseref", :id => false, :force => true do |t|
    t.string  "dtype",               :limit => 31, :null => false
    t.integer "persistenceid",       :limit => 8,  :null => false
    t.string  "_pref"
    t.string  "ref"
    t.integer "_frel_persistenceid", :limit => 8
    t.integer "_mrel_persistenceid", :limit => 8
  end

  create_table "stores", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
    t.integer  "user_id"
    t.string   "slug"
    t.text     "return_policy"
  end

  add_index "stores", ["slug"], :name => "index_stores_on_slug"
  add_index "stores", ["user_id"], :name => "index_stores_on_user_id"

  create_table "submission", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8, :null => false
    t.string  "desc"
    t.string  "id"
    t.string  "ordi"
  end

  create_table "submitter", :id => false, :force => true do |t|
    t.integer "persistenceid",      :limit => 8, :null => false
    t.string  "_email"
    t.string  "_www"
    t.string  "emailtag"
    t.string  "id"
    t.string  "lang"
    t.string  "name"
    t.string  "phon"
    t.string  "rin"
    t.string  "value"
    t.string  "wwwtag"
    t.integer "addr_persistenceid", :limit => 8
    t.integer "chan_persistenceid", :limit => 8
  end

  create_table "treelines_accounts_defaultavatar", :force => true do |t|
    t.string "image", :limit => 100, :null => false
  end

  create_table "treelines_accounts_facebookaccountlink", :force => true do |t|
    t.integer "user_id",          :null => false
    t.integer "facebook_user_id", :null => false
  end

  add_index "treelines_accounts_facebookaccountlink", ["facebook_user_id"], :name => "treelines_accounts_facebookaccountlink_facebook_user_id"
  add_index "treelines_accounts_facebookaccountlink", ["user_id"], :name => "treelines_accounts_facebookaccountlink_user_id_key", :unique => true

  create_table "treelines_accounts_facebookregistrationtoken", :force => true do |t|
    t.integer  "user_id",                      :null => false
    t.string   "activation_key", :limit => 40, :null => false
    t.datetime "created_on",                   :null => false
  end

  add_index "treelines_accounts_facebookregistrationtoken", ["user_id"], :name => "treelines_accounts_facebookregistrationtoken_user_id_key", :unique => true

  create_table "treelines_accounts_twitteraccountlink", :force => true do |t|
    t.integer "user_id",         :null => false
    t.string  "twitter_user_id", :null => false
  end

  add_index "treelines_accounts_twitteraccountlink", ["user_id"], :name => "treelines_accounts_twitteraccountlink_user_id_key", :unique => true

  create_table "treelines_accounts_usergedcomlink", :force => true do |t|
    t.integer  "gedcom_id",                 :null => false
    t.integer  "user_id",                   :null => false
    t.datetime "date_added",                :null => false
    t.string   "access_level", :limit => 1, :null => false
    t.boolean  "library",                   :null => false
    t.integer  "gedperson_id"
  end

  add_index "treelines_accounts_usergedcomlink", ["gedcom_id", "user_id"], :name => "treelines_accounts_usergedcomlin_gedcom_id_57bfd6ae8e70492_uniq", :unique => true
  add_index "treelines_accounts_usergedcomlink", ["gedcom_id"], :name => "treelines_accounts_usergedcomlink_gedcom_id"
  add_index "treelines_accounts_usergedcomlink", ["gedperson_id"], :name => "treelines_accounts_usergedcomlink_gedperson_id"

  create_table "treelines_accounts_userprofile", :force => true do |t|
    t.integer "user_id",                                                       :null => false
    t.boolean "is_confirmed",                                                  :null => false
    t.integer "credits",                                                       :null => false
    t.boolean "show_intro",                                  :default => true, :null => false
    t.boolean "is_enabled",                                                    :null => false
    t.string  "sex",                          :limit => 1
    t.string  "location"
    t.boolean "newsletter_optin",                                              :null => false
    t.string  "discount_code"
    t.boolean "military_raffle_optin",                                         :null => false
    t.date    "birthdate"
    t.string  "blog_url"
    t.string  "tree_url"
    t.string  "facebook_handle"
    t.string  "twitter_handle"
    t.text    "bio"
    t.string  "pinterest_handle",             :limit => 256
    t.string  "avatar_image",                 :limit => 100
    t.string  "avatar_crop_coordinates",      :limit => 40
    t.boolean "receive_activity_emails",                                       :null => false
    t.string  "default_story_privacy",        :limit => 1,                     :null => false
    t.string  "default_living_privacy",       :limit => 1,                     :null => false
    t.string  "default_dead_privacy",         :limit => 1,                     :null => false
    t.integer "default_avatar_id"
    t.string  "avatar_image_cropped",         :limit => 100
    t.string  "avatar_image_large_thumbnail", :limit => 100
    t.string  "avatar_image_small_thumbnail", :limit => 100
  end

  add_index "treelines_accounts_userprofile", ["default_avatar_id"], :name => "treelines_accounts_userprofile_default_avatar_id"
  add_index "treelines_accounts_userprofile", ["user_id"], :name => "treelines_accounts_userprofile_user_id_key", :unique => true

  create_table "treelines_accounts_userprofileboast", :force => true do |t|
    t.integer "user_id",  :null => false
    t.integer "boast_id", :null => false
  end

  add_index "treelines_accounts_userprofileboast", ["boast_id"], :name => "treelines_accounts_userprofileboast_boast_id"
  add_index "treelines_accounts_userprofileboast", ["user_id", "boast_id"], :name => "treelines_accounts_userprofileboast_user_id_boast_id_key", :unique => true
  add_index "treelines_accounts_userprofileboast", ["user_id"], :name => "treelines_accounts_userprofileboast_user_id"

  create_table "treelines_accounts_userprofileboastlink", :force => true do |t|
    t.integer "userprofile_id", :null => false
    t.integer "boast_id",       :null => false
  end

  add_index "treelines_accounts_userprofileboastlink", ["boast_id"], :name => "treelines_accounts_userprofileboastlink_boast_id"
  add_index "treelines_accounts_userprofileboastlink", ["userprofile_id", "boast_id"], :name => "treelines_accounts_userprofileboastlink_user_id_boast_id_key", :unique => true
  add_index "treelines_accounts_userprofileboastlink", ["userprofile_id"], :name => "treelines_accounts_userprofileboastlink_user_id"

  create_table "treelines_accounts_userprofileplacelink", :force => true do |t|
    t.integer "userprofile_id", :null => false
    t.integer "place_id",       :null => false
  end

  add_index "treelines_accounts_userprofileplacelink", ["place_id"], :name => "treelines_accounts_userprofileplacelink_place_id"
  add_index "treelines_accounts_userprofileplacelink", ["userprofile_id", "place_id"], :name => "treelines_accounts_userprofileplace_userprofile_id_place_id_key", :unique => true
  add_index "treelines_accounts_userprofileplacelink", ["userprofile_id"], :name => "treelines_accounts_userprofileplacelink_userprofile_id"

  create_table "treelines_accounts_userprofilesurnamelink", :force => true do |t|
    t.integer "userprofile_id", :null => false
    t.integer "surname_id",     :null => false
  end

  add_index "treelines_accounts_userprofilesurnamelink", ["surname_id"], :name => "treelines_accounts_userprofilesurnamelink_surname_id"
  add_index "treelines_accounts_userprofilesurnamelink", ["userprofile_id", "surname_id"], :name => "treelines_accounts_userprofilesur_userprofile_id_surname_id_key", :unique => true
  add_index "treelines_accounts_userprofilesurnamelink", ["userprofile_id"], :name => "treelines_accounts_userprofilesurnamelink_userprofile_id"

  create_table "treelines_accounts_userprofiletaglink", :force => true do |t|
    t.integer "userprofile_id", :null => false
    t.integer "tag_id",         :null => false
  end

  add_index "treelines_accounts_userprofiletaglink", ["tag_id"], :name => "treelines_accounts_userprofiletaglink_tag_id"
  add_index "treelines_accounts_userprofiletaglink", ["userprofile_id", "tag_id"], :name => "treelines_accounts_userprofiletaglink_userprofile_id_tag_id_key", :unique => true
  add_index "treelines_accounts_userprofiletaglink", ["userprofile_id"], :name => "treelines_accounts_userprofiletaglink_userprofile_id"

  create_table "treelines_boast", :force => true do |t|
    t.string "name", :limit => 100, :null => false
    t.string "img",  :limit => 100
  end

  create_table "treelines_emails_transactionalemail", :force => true do |t|
    t.string "internal_name", :limit => 50,  :null => false
    t.string "subject",       :limit => 200, :null => false
    t.text   "body",                         :null => false
    t.string "name",          :limit => 200
  end

  add_index "treelines_emails_transactionalemail", ["internal_name"], :name => "treelines_emails_transactionalemail_internal_name_key", :unique => true

  create_table "treelines_featuredplace", :force => true do |t|
    t.integer "place_id", :null => false
  end

  add_index "treelines_featuredplace", ["place_id"], :name => "treelines_featuredplace_place_id_key", :unique => true

  create_table "treelines_featuredsurname", :force => true do |t|
    t.integer "surname_id", :null => false
  end

  add_index "treelines_featuredsurname", ["surname_id"], :name => "treelines_featuredsurname_surname_id_key", :unique => true

  create_table "treelines_featuredtopic", :force => true do |t|
    t.integer "topic_id", :null => false
  end

  add_index "treelines_featuredtopic", ["topic_id"], :name => "treelines_featuredtopic_topic_id_key", :unique => true

  create_table "treelines_gatepage", :force => true do |t|
    t.string "name",  :null => false
    t.text   "value"
  end

  create_table "treelines_gedcom_gedcomupload", :force => true do |t|
    t.integer  "uploader_id",                  :null => false
    t.string   "filepath",      :limit => 100, :null => false
    t.datetime "date_uploaded",                :null => false
    t.integer  "status",        :limit => 2,   :null => false
  end

  add_index "treelines_gedcom_gedcomupload", ["uploader_id"], :name => "treelines_gedcom_gedcomupload_uploader_id"
  add_index "treelines_gedcom_gedcomupload", ["uploader_id"], :name => "treelines_gedcom_usergedcom_uploader_id"

  create_table "treelines_gedcom_person_computed", :id => false, :force => true do |t|
    t.integer "persistenceid", :limit => 8,                               :null => false
    t.string  "name",                                                     :null => false
    t.decimal "yr1",                        :precision => 6, :scale => 2, :null => false
    t.decimal "yr2",                        :precision => 6, :scale => 2, :null => false
    t.decimal "estyr1",                     :precision => 6, :scale => 2, :null => false
    t.boolean "softstart",                                                :null => false
    t.boolean "softend",                                                  :null => false
  end

  create_table "treelines_homepage", :force => true do |t|
    t.string   "headline",                       :null => false
    t.string   "summary",                        :null => false
    t.datetime "last_updated",                   :null => false
    t.string   "story_kicker1"
    t.integer  "story1_id"
    t.string   "story_kicker2"
    t.integer  "story2_id"
    t.string   "story_kicker3"
    t.integer  "story3_id"
    t.string   "story_kicker4"
    t.integer  "story4_id"
    t.string   "article_kicker1"
    t.integer  "article1_id"
    t.string   "article_kicker2"
    t.integer  "article2_id"
    t.string   "article_kicker3"
    t.integer  "article3_id"
    t.string   "article_kicker4"
    t.integer  "article4_id"
    t.string   "link_kicker1"
    t.string   "link_headline1"
    t.string   "link_url1"
    t.string   "link_kicker2"
    t.string   "link_headline2"
    t.string   "link_url2"
    t.string   "link_kicker3"
    t.string   "link_headline3"
    t.string   "link_url3"
    t.string   "link_kicker4"
    t.string   "link_headline4"
    t.string   "link_url4"
    t.string   "box_title",                      :null => false
    t.string   "link_image1",     :limit => 100
    t.string   "link_image2",     :limit => 100
    t.string   "link_image3",     :limit => 100
    t.string   "link_image4",     :limit => 100
  end

  add_index "treelines_homepage", ["article1_id"], :name => "treelines_homepage_article1_id"
  add_index "treelines_homepage", ["article2_id"], :name => "treelines_homepage_article2_id"
  add_index "treelines_homepage", ["article3_id"], :name => "treelines_homepage_article3_id"
  add_index "treelines_homepage", ["article4_id"], :name => "treelines_homepage_article4_id"
  add_index "treelines_homepage", ["story1_id"], :name => "treelines_homepage_story1_id"
  add_index "treelines_homepage", ["story2_id"], :name => "treelines_homepage_story2_id"
  add_index "treelines_homepage", ["story3_id"], :name => "treelines_homepage_story3_id"
  add_index "treelines_homepage", ["story4_id"], :name => "treelines_homepage_story4_id"

  create_table "treelines_homepage_featured_user", :force => true do |t|
    t.integer "homepage_id",     :null => false
    t.integer "featureduser_id", :null => false
  end

  add_index "treelines_homepage_featured_user", ["featureduser_id"], :name => "treelines_homepage_featured_user_featureduser_id"
  add_index "treelines_homepage_featured_user", ["homepage_id", "featureduser_id"], :name => "treelines_homepage_featured_use_homepage_id_featureduser_id_key", :unique => true
  add_index "treelines_homepage_featured_user", ["homepage_id"], :name => "treelines_homepage_featured_user_homepage_id"

  create_table "treelines_homepagestorylink", :force => true do |t|
    t.integer "story_id",    :null => false
    t.integer "homepage_id", :null => false
  end

  add_index "treelines_homepagestorylink", ["homepage_id"], :name => "treelines_homepagestorylink_homepage_id"
  add_index "treelines_homepagestorylink", ["story_id", "homepage_id"], :name => "treelines_homepagestorylink_story_id_85d5e3a014bfe3c_uniq", :unique => true
  add_index "treelines_homepagestorylink", ["story_id"], :name => "treelines_homepagestorylink_story_id"

  create_table "treelines_library_article", :force => true do |t|
    t.string   "headline",                    :null => false
    t.text     "body",                        :null => false
    t.integer  "author_id",                   :null => false
    t.boolean  "published",                   :null => false
    t.string   "slug",         :limit => 50,  :null => false
    t.datetime "last_updated",                :null => false
    t.string   "image",        :limit => 100
    t.integer  "taxonomy_id"
    t.text     "summary",                     :null => false
  end

  add_index "treelines_library_article", ["author_id"], :name => "treelines_library_article_author_id"
  add_index "treelines_library_article", ["slug"], :name => "treelines_library_article_slug"
  add_index "treelines_library_article", ["slug"], :name => "treelines_library_article_slug_like"
  add_index "treelines_library_article", ["taxonomy_id"], :name => "treelines_library_article_taxonomy_id"

  create_table "treelines_library_articletaxonomy", :force => true do |t|
    t.string "display_name",               :null => false
    t.string "slug",         :limit => 50, :null => false
    t.text   "summary",                    :null => false
  end

  add_index "treelines_library_articletaxonomy", ["slug"], :name => "treelines_library_articletaxonomy_slug"
  add_index "treelines_library_articletaxonomy", ["slug"], :name => "treelines_library_articletaxonomy_slug_like"

  create_table "treelines_stories_story", :force => true do |t|
    t.string   "title",                                                    :null => false
    t.string   "summary",                                                  :null => false
    t.integer  "author_id",                                                :null => false
    t.boolean  "published",                                                :null => false
    t.datetime "last_updated",                                             :null => false
    t.boolean  "public",                                :default => false, :null => false
    t.string   "startdate",              :limit => 35
    t.string   "enddate",                :limit => 35
    t.text     "metadata_json",                                            :null => false
    t.text     "treeline_json",                                            :null => false
    t.datetime "pubdate"
    t.boolean  "editors_pick",                          :default => false, :null => false
    t.integer  "gedcom_id",              :limit => 8
    t.string   "image",                  :limit => 100
    t.string   "image_crop_coordinates", :limit => 40
    t.string   "hp_image",               :limit => 100
    t.boolean  "living_obscured",                                          :null => false
    t.boolean  "dead_obscured",                                            :null => false
    t.boolean  "deleted",                                                  :null => false
    t.boolean  "world_readable",                                           :null => false
    t.integer  "comments_count",                                           :null => false
    t.string   "image_cropped",          :limit => 100
    t.string   "image_background",       :limit => 100
    t.string   "image_cover",            :limit => 100
    t.string   "image_builder_edit",     :limit => 100
  end

  add_index "treelines_stories_story", ["author_id"], :name => "treelines_stories_story_author_id"

  create_table "treelines_stories_storyinvite", :force => true do |t|
    t.integer  "story_id",       :null => false
    t.integer  "invite_from_id", :null => false
    t.integer  "invite_to_id",   :null => false
    t.datetime "invited_on",     :null => false
    t.boolean  "write_access",   :null => false
  end

  add_index "treelines_stories_storyinvite", ["invite_from_id"], :name => "treelines_stories_storyinvite_invite_from_id"
  add_index "treelines_stories_storyinvite", ["invite_to_id"], :name => "treelines_stories_storyinvite_invite_to_id"
  add_index "treelines_stories_storyinvite", ["story_id"], :name => "treelines_stories_storyinvite_story_id"

  create_table "treelines_stories_storypage", :force => true do |t|
    t.integer "story_id",                               :null => false
    t.integer "page_number",                            :null => false
    t.text    "description",                            :null => false
    t.string  "image",                   :limit => 100
    t.string  "image_crop_coordinates",  :limit => 40
    t.integer "gedcom_event_id"
    t.string  "image_cropped",           :limit => 100
    t.string  "image_builder_thumbnail", :limit => 100
    t.string  "image_story_viewer",      :limit => 100
  end

  add_index "treelines_stories_storypage", ["gedcom_event_id"], :name => "treelines_stories_storypage_gedcom_event_id"
  add_index "treelines_stories_storypage", ["story_id"], :name => "treelines_stories_storypage_story_id"

  create_table "treelines_stories_storypageattributes", :force => true do |t|
    t.string "type",      :limit => 1,  :null => false
    t.string "css_class", :limit => 50, :null => false
  end

  create_table "treelines_stories_storypersonlink", :force => true do |t|
    t.integer "story_id",               :null => false
    t.integer "person_id", :limit => 8, :null => false
  end

  add_index "treelines_stories_storypersonlink", ["person_id"], :name => "treelines_stories_storypersonlink_person_id"
  add_index "treelines_stories_storypersonlink", ["story_id", "person_id"], :name => "treelines_stories_storypersonlin_story_id_3e55201923f816a2_uniq", :unique => true
  add_index "treelines_stories_storypersonlink", ["story_id"], :name => "treelines_stories_storypersonlink_story_id"

  create_table "treelines_stories_storyplacelink", :force => true do |t|
    t.integer "story_id", :null => false
    t.integer "place_id", :null => false
    t.integer "order",    :null => false
  end

  add_index "treelines_stories_storyplacelink", ["place_id"], :name => "treelines_stories_storyplacelink_place_id"
  add_index "treelines_stories_storyplacelink", ["story_id", "place_id"], :name => "treelines_stories_storyplacelink_story_id_place_id_key", :unique => true
  add_index "treelines_stories_storyplacelink", ["story_id"], :name => "treelines_stories_storyplacelink_story_id"

  create_table "treelines_stories_storysurnamelink", :force => true do |t|
    t.integer "story_id",   :null => false
    t.integer "surname_id", :null => false
    t.integer "order",      :null => false
  end

  add_index "treelines_stories_storysurnamelink", ["story_id", "surname_id"], :name => "treelines_stories_storysurnamelink_story_id_surname_id_key", :unique => true
  add_index "treelines_stories_storysurnamelink", ["story_id"], :name => "treelines_stories_storysurnamelink_story_id"
  add_index "treelines_stories_storysurnamelink", ["surname_id"], :name => "treelines_stories_storysurnamelink_surname_id"

  create_table "treelines_stories_storytaglink", :force => true do |t|
    t.integer "story_id", :null => false
    t.integer "tag_id",   :null => false
    t.integer "order",    :null => false
  end

  add_index "treelines_stories_storytaglink", ["story_id"], :name => "treelines_stories_story_tag_story_id"
  add_index "treelines_stories_storytaglink", ["tag_id"], :name => "treelines_stories_story_tag_tag_id"

  create_table "treelines_stories_storytreelinerebuildtask", :force => true do |t|
    t.integer  "story_id",          :null => false
    t.datetime "created_at",        :null => false
    t.datetime "should_rebuild_at"
    t.datetime "started_at"
    t.datetime "completed_at"
  end

  add_index "treelines_stories_storytreelinerebuildtask", ["story_id"], :name => "treelines_stories_storytreelinerebuildtask_story_id"

  create_table "treelines_storycovertemplate", :force => true do |t|
    t.string "name",                     :null => false
    t.string "img_thumb", :limit => 100
    t.string "img_full",  :limit => 100
  end

  add_index "treelines_storycovertemplate", ["name"], :name => "treelines_storycovertemplate_name_key", :unique => true

  create_table "treelines_storypagetemplate", :force => true do |t|
    t.string "name",                         :null => false
    t.string "event_default", :limit => 1
    t.string "img_preview",   :limit => 100
    t.string "css_class",     :limit => 36
  end

  add_index "treelines_storypagetemplate", ["name"], :name => "treelines_storypagetemplate_name_key", :unique => true

  create_table "treelines_taxonomy_place", :force => true do |t|
    t.integer  "remote_id"
    t.string   "placename",                    :null => false
    t.string   "shortname",                    :null => false
    t.boolean  "staff_created",                :null => false
    t.integer  "created_by_id",                :null => false
    t.datetime "create_date",                  :null => false
    t.integer  "remote_level",  :default => 0, :null => false
  end

  add_index "treelines_taxonomy_place", ["created_by_id"], :name => "treelines_taxonomy_place_created_by_id"
  add_index "treelines_taxonomy_place", ["placename"], :name => "treelines_taxonomy_place_placename_key", :unique => true
  add_index "treelines_taxonomy_place", ["remote_id"], :name => "treelines_taxonomy_place_remote_id"
  add_index "treelines_taxonomy_place", ["remote_id"], :name => "treelines_taxonomy_place_remote_id_uniq", :unique => true

  create_table "treelines_taxonomy_surname", :force => true do |t|
    t.string   "surname",       :null => false
    t.boolean  "staff_created", :null => false
    t.integer  "created_by_id", :null => false
    t.datetime "create_date",   :null => false
  end

  add_index "treelines_taxonomy_surname", ["created_by_id"], :name => "treelines_taxonomy_surname_created_by_id"
  add_index "treelines_taxonomy_surname", ["surname"], :name => "treelines_taxonomy_surname_surname_key", :unique => true

  create_table "treelines_taxonomy_tag", :force => true do |t|
    t.string   "tagname",       :null => false
    t.boolean  "staff_created", :null => false
    t.integer  "created_by_id", :null => false
    t.datetime "create_date",   :null => false
  end

  add_index "treelines_taxonomy_tag", ["created_by_id"], :name => "treelines_taxonomy_tag_created_by_id"
  add_index "treelines_taxonomy_tag", ["tagname"], :name => "treelines_taxonomy_tag_tagname_key", :unique => true

  create_table "user_product_images", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "website"
    t.string   "last_name"
    t.string   "business_name"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "phone_number"
    t.boolean  "tos"
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "thumbnail"
    t.string   "access_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
