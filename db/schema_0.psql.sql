-- Converted by db_converter
START TRANSACTION;
SET standard_conforming_strings=off;
SET escape_string_warning=off;
SET CONSTRAINTS ALL DEFERRED;

CREATE TABLE "application" (
    "id" integer NOT NULL,
    "name" varchar(510) NOT NULL,
    "key" varchar(128) NOT NULL,
    "context_template" text ,
    "summary_template" text ,
    "sample_context" text ,
    "mobile_template" text ,
    "auth_only" int4 DEFAULT '0',
    "allow_other_app_incidents" int4  NOT NULL DEFAULT '0',
    "allow_authenticating_users" int4  NOT NULL DEFAULT '0',
    "secondary_key" varchar(128) DEFAULT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("name")
);

CREATE TABLE "application_mode" (
    "application_id" integer NOT NULL,
    "mode_id" integer NOT NULL,
    PRIMARY KEY ("application_id","mode_id")
);

CREATE TABLE "application_owner" (
    "application_id" integer NOT NULL,
    "user_id" bigint NOT NULL,
    PRIMARY KEY ("application_id","user_id")
);

CREATE TABLE "application_quota" (
    "application_id" integer NOT NULL,
    "hard_quota_threshold" int2 NOT NULL,
    "soft_quota_threshold" int2 NOT NULL,
    "hard_quota_duration" int2 NOT NULL,
    "soft_quota_duration" int2 NOT NULL,
    "plan_name" varchar(510) DEFAULT NULL,
    "target_id" bigint DEFAULT NULL,
    "wait_time" int2 NOT NULL DEFAULT '0',
    PRIMARY KEY ("application_id")
);

CREATE TABLE "application_stats" (
    "application_id" integer NOT NULL,
    "statistic" varchar(510) NOT NULL,
    "value" float NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    PRIMARY KEY ("application_id","statistic")
);

CREATE TABLE "default_application_mode" (
    "application_id" integer NOT NULL,
    "priority_id" integer NOT NULL,
    "mode_id" integer NOT NULL,
    PRIMARY KEY ("application_id","priority_id")
);

CREATE TABLE "device" (
    "id" bigint NOT NULL,
    "registration_id" varchar(510) NOT NULL,
    "user_id" bigint NOT NULL,
    "platform" varchar(510) NOT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("registration_id")
);

CREATE TABLE "dynamic_plan_map" (
    "incident_id" bigint NOT NULL,
    "dynamic_index" integer NOT NULL,
    "role_id" integer NOT NULL,
    "target_id" bigint NOT NULL,
    PRIMARY KEY ("incident_id","dynamic_index")
);

CREATE TABLE "generic_message_sent_status" (
    "message_id" bigint NOT NULL,
    "status" int4 NOT NULL,
    PRIMARY KEY ("message_id")
);

CREATE TABLE "incident" (
    "id" bigint NOT NULL,
    "plan_id" bigint NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "updated" timestamp with time zone DEFAULT NULL,
    "context" text ,
    "owner_id" bigint DEFAULT NULL,
    "application_id" integer NOT NULL,
    "current_step" integer NOT NULL,
    "active" int4 NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "incident_emails" (
    "email" varchar(510) NOT NULL,
    "application_id" integer NOT NULL,
    "plan_name" varchar(510) NOT NULL,
    PRIMARY KEY ("email")
);

CREATE TABLE "mailing_list" (
    "target_id" bigint NOT NULL,
    "count" bigint NOT NULL DEFAULT '0',
    PRIMARY KEY ("target_id")
);

CREATE TABLE "mailing_list_membership" (
    "list_id" bigint NOT NULL,
    "user_id" bigint NOT NULL,
    PRIMARY KEY ("list_id","user_id")
);

CREATE TABLE "message" (
    "id" bigint NOT NULL,
    "batch" varchar(64) DEFAULT NULL,
    "created" timestamp with time zone NOT NULL,
    "sent" timestamp with time zone DEFAULT NULL,
    "application_id" integer NOT NULL,
    "target_id" bigint NOT NULL,
    "destination" varchar(510) DEFAULT NULL,
    "mode_id" integer DEFAULT NULL,
    "plan_id" bigint DEFAULT NULL,
    "priority_id" integer NOT NULL,
    "subject" varchar(510) DEFAULT NULL,
    "body" text ,
    "incident_id" bigint DEFAULT NULL,
    "plan_notification_id" bigint DEFAULT NULL,
    "active" int4 NOT NULL DEFAULT '1',
    "template_id" integer DEFAULT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "message_changelog" (
    "id" bigint NOT NULL,
    "date" timestamp with time zone NOT NULL,
    "message_id" bigint NOT NULL,
    "change_type" varchar(510) NOT NULL,
    "old" varchar(510) NOT NULL,
    "new" varchar(510) NOT NULL,
    "description" varchar(510) DEFAULT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "mode" (
    "id" integer NOT NULL,
    "name" varchar(510) NOT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("name")
);

CREATE TABLE "plan" (
    "id" bigint NOT NULL,
    "name" varchar(510) NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "user_id" bigint NOT NULL,
    "team_id" bigint DEFAULT NULL,
    "description" text ,
    "step_count" integer NOT NULL,
    "threshold_window" bigint DEFAULT NULL,
    "threshold_count" bigint DEFAULT NULL,
    "aggregation_window" bigint DEFAULT NULL,
    "aggregation_reset" bigint DEFAULT NULL,
    "tracking_key" varchar(510) DEFAULT NULL,
    "tracking_type" varchar(510) DEFAULT NULL,
    "tracking_template" text ,
    PRIMARY KEY ("id")
);

CREATE TABLE "plan_active" (
    "name" varchar(510) NOT NULL,
    "plan_id" bigint NOT NULL,
    PRIMARY KEY ("name"),
    UNIQUE ("plan_id")
);

CREATE TABLE "plan_notification" (
    "id" bigint NOT NULL,
    "plan_id" bigint NOT NULL,
    "step" integer NOT NULL,
    "template" varchar(510) DEFAULT NULL,
    "target_id" bigint DEFAULT NULL,
    "role_id" integer DEFAULT NULL,
    "priority_id" integer NOT NULL,
    "repeat" integer NOT NULL DEFAULT '0',
    "wait" integer NOT NULL DEFAULT '0',
    "dynamic_index" integer DEFAULT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "priority" (
    "id" integer NOT NULL,
    "name" varchar(510) NOT NULL,
    "mode_id" integer NOT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("name")
);

CREATE TABLE "response" (
    "id" bigint NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "message_id" bigint NOT NULL,
    "content" text NOT NULL,
    "source" varchar(510) NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "target" (
    "id" bigint NOT NULL,
    "name" varchar(510) NOT NULL,
    "type_id" integer NOT NULL,
    "active" int4 NOT NULL DEFAULT '1',
    PRIMARY KEY ("id"),
    UNIQUE ("name","type_id")
);

CREATE TABLE "target_application_mode" (
    "target_id" bigint NOT NULL,
    "application_id" integer NOT NULL,
    "priority_id" integer NOT NULL,
    "mode_id" integer NOT NULL,
    PRIMARY KEY ("target_id","application_id","priority_id")
);

CREATE TABLE "target_contact" (
    "target_id" bigint NOT NULL,
    "mode_id" integer NOT NULL,
    "destination" varchar(510) NOT NULL,
    PRIMARY KEY ("target_id","mode_id")
);

CREATE TABLE "target_mode" (
    "target_id" bigint NOT NULL,
    "priority_id" integer NOT NULL,
    "mode_id" integer NOT NULL,
    PRIMARY KEY ("target_id","priority_id")
);

CREATE TABLE "target_reprioritization" (
    "target_id" bigint NOT NULL,
    "src_mode_id" integer NOT NULL,
    "dst_mode_id" integer NOT NULL,
    "count" int4  NOT NULL,
    "duration" int2  NOT NULL,
    PRIMARY KEY ("target_id","src_mode_id")
);

CREATE TABLE "target_role" (
    "id" integer NOT NULL,
    "name" varchar(510) NOT NULL,
    "type_id" integer NOT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("name")
);

CREATE TABLE "target_type" (
    "id" integer NOT NULL,
    "name" varchar(510) NOT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("name")
);

CREATE TABLE "team" (
    "target_id" bigint NOT NULL,
    "manager_id" bigint DEFAULT NULL,
    "director_id" bigint DEFAULT NULL,
    PRIMARY KEY ("target_id"),
    UNIQUE ("target_id")
);

CREATE TABLE "template" (
    "id" integer NOT NULL,
    "name" varchar(510) NOT NULL,
    "created" timestamp with time zone NOT NULL,
    "user_id" bigint NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "template_active" (
    "name" varchar(510) NOT NULL,
    "template_id" integer NOT NULL,
    PRIMARY KEY ("name"),
    UNIQUE ("template_id")
);

CREATE TABLE "template_content" (
    "template_id" integer NOT NULL,
    "application_id" integer NOT NULL,
    "mode_id" integer NOT NULL,
    "subject" varchar(510) NOT NULL,
    "body" text NOT NULL,
    "call" text ,
    "sms" text ,
    "im" text ,
    "email_subject" varchar(510) DEFAULT NULL,
    "email_text" text ,
    "email_html" text ,
    PRIMARY KEY ("template_id","application_id","mode_id")
);

CREATE TABLE "template_variable" (
    "id" integer NOT NULL,
    "application_id" integer NOT NULL,
    "name" varchar(510) NOT NULL,
    "required" int4 NOT NULL DEFAULT '0',
    PRIMARY KEY ("id")
);

CREATE TABLE "twilio_delivery_status" (
    "twilio_sid" varchar(68) NOT NULL,
    "message_id" bigint DEFAULT NULL,
    "status" varchar(60) DEFAULT NULL,
    PRIMARY KEY ("twilio_sid")
);

CREATE TABLE "twilio_retry" (
    "message_id" bigint NOT NULL,
    "retry_id" bigint NOT NULL,
    PRIMARY KEY ("message_id")
);

CREATE TABLE "user" (
    "target_id" bigint NOT NULL,
    "admin" int4  NOT NULL DEFAULT '0',
    PRIMARY KEY ("target_id")
);

CREATE TABLE "user_setting" (
    "user_id" bigint NOT NULL,
    "name" varchar(510) NOT NULL,
    "value" varchar(510) NOT NULL,
    PRIMARY KEY ("user_id","name")
);

CREATE TABLE "user_team" (
    "user_id" bigint NOT NULL,
    "team_id" bigint NOT NULL,
    PRIMARY KEY ("user_id","team_id")
);


-- Post-data save --
COMMIT;
START TRANSACTION;

-- Typecasts --
ALTER TABLE "application" ALTER COLUMN "auth_only" DROP DEFAULT, ALTER COLUMN "auth_only" TYPE boolean USING CAST("auth_only" as boolean);
ALTER TABLE "application" ALTER COLUMN "allow_other_app_incidents" DROP DEFAULT, ALTER COLUMN "allow_other_app_incidents" TYPE boolean USING CAST("allow_other_app_incidents" as boolean);
ALTER TABLE "application" ALTER COLUMN "allow_authenticating_users" DROP DEFAULT, ALTER COLUMN "allow_authenticating_users" TYPE boolean USING CAST("allow_authenticating_users" as boolean);
ALTER TABLE "generic_message_sent_status" ALTER COLUMN "status" DROP DEFAULT, ALTER COLUMN "status" TYPE boolean USING CAST("status" as boolean);
ALTER TABLE "incident" ALTER COLUMN "active" DROP DEFAULT, ALTER COLUMN "active" TYPE boolean USING CAST("active" as boolean);
ALTER TABLE "message" ALTER COLUMN "active" DROP DEFAULT, ALTER COLUMN "active" TYPE boolean USING CAST("active" as boolean);
ALTER TABLE "target" ALTER COLUMN "active" DROP DEFAULT, ALTER COLUMN "active" TYPE boolean USING CAST("active" as boolean);
ALTER TABLE "target_reprioritization" ALTER COLUMN "count" DROP DEFAULT, ALTER COLUMN "count" TYPE boolean USING CAST("count" as boolean);
ALTER TABLE "template_variable" ALTER COLUMN "required" DROP DEFAULT, ALTER COLUMN "required" TYPE boolean USING CAST("required" as boolean);
ALTER TABLE "user" ALTER COLUMN "admin" DROP DEFAULT, ALTER COLUMN "admin" TYPE boolean USING CAST("admin" as boolean);

-- Foreign keys --
ALTER TABLE "application_mode" ADD CONSTRAINT "application_mode_application_id_ibfk" FOREIGN KEY ("application_id") REFERENCES "application" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "application_mode" ("application_id");
ALTER TABLE "application_mode" ADD CONSTRAINT "application_mode_mode_id_ibfk" FOREIGN KEY ("mode_id") REFERENCES "mode" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "application_mode" ("mode_id");
ALTER TABLE "application_owner" ADD CONSTRAINT "application_owner_application_id_ibfk" FOREIGN KEY ("application_id") REFERENCES "application" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "application_owner" ("application_id");
ALTER TABLE "application_owner" ADD CONSTRAINT "application_owner_user_id_ibfk" FOREIGN KEY ("user_id") REFERENCES "user" ("target_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "application_owner" ("user_id");
ALTER TABLE "application_quota" ADD CONSTRAINT "application_id_ibfk" FOREIGN KEY ("application_id") REFERENCES "application" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "application_quota" ("application_id");
ALTER TABLE "application_quota" ADD CONSTRAINT "plan_name_ibfk" FOREIGN KEY ("plan_name") REFERENCES "plan_active" ("name") ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "application_quota" ("plan_name");
ALTER TABLE "application_quota" ADD CONSTRAINT "target_id_ibfk" FOREIGN KEY ("target_id") REFERENCES "target" ("id") ON DELETE SET NULL ON UPDATE SET NULL DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "application_quota" ("target_id");
ALTER TABLE "application_stats" ADD CONSTRAINT "application_stats_app_id_ibfk" FOREIGN KEY ("application_id") REFERENCES "application" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "application_stats" ("application_id");
ALTER TABLE "default_application_mode" ADD CONSTRAINT "default_application_mode_ibfk_1" FOREIGN KEY ("application_id") REFERENCES "application" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "default_application_mode" ("application_id");
ALTER TABLE "default_application_mode" ADD CONSTRAINT "default_application_mode_ibfk_2" FOREIGN KEY ("priority_id") REFERENCES "priority" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "default_application_mode" ("priority_id");
ALTER TABLE "default_application_mode" ADD CONSTRAINT "default_application_mode_ibfk_3" FOREIGN KEY ("mode_id") REFERENCES "mode" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "default_application_mode" ("mode_id");
ALTER TABLE "device" ADD CONSTRAINT "device_user_id_ibfk" FOREIGN KEY ("user_id") REFERENCES "user" ("target_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "device" ("user_id");
ALTER TABLE "dynamic_plan_map" ADD CONSTRAINT "dynamic_plan_map_ibfk_1" FOREIGN KEY ("target_id") REFERENCES "target" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "dynamic_plan_map" ("target_id");
ALTER TABLE "dynamic_plan_map" ADD CONSTRAINT "dynamic_plan_map_ibfk_2" FOREIGN KEY ("role_id") REFERENCES "target_role" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "dynamic_plan_map" ("role_id");
ALTER TABLE "dynamic_plan_map" ADD CONSTRAINT "dynamic_plan_map_ibfk_3" FOREIGN KEY ("incident_id") REFERENCES "incident" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "dynamic_plan_map" ("incident_id");
ALTER TABLE "generic_message_sent_status" ADD CONSTRAINT "generic_message_sent_status_message_id_ibfk" FOREIGN KEY ("message_id") REFERENCES "message" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "generic_message_sent_status" ("message_id");
ALTER TABLE "incident" ADD CONSTRAINT "incident_ibfk_1" FOREIGN KEY ("plan_id") REFERENCES "plan" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "incident" ("plan_id");
ALTER TABLE "incident" ADD CONSTRAINT "incident_ibfk_2" FOREIGN KEY ("owner_id") REFERENCES "user" ("target_id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "incident" ("owner_id");
ALTER TABLE "incident" ADD CONSTRAINT "incident_ibfk_3" FOREIGN KEY ("application_id") REFERENCES "application" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "incident" ("application_id");
ALTER TABLE "incident_emails" ADD CONSTRAINT "incident_emails_application_id_ibfk" FOREIGN KEY ("application_id") REFERENCES "application" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "incident_emails" ("application_id");
ALTER TABLE "incident_emails" ADD CONSTRAINT "incident_emails_plan_name_ibfk" FOREIGN KEY ("plan_name") REFERENCES "plan_active" ("name") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "incident_emails" ("plan_name");
ALTER TABLE "mailing_list" ADD CONSTRAINT "mailing_list_ibfk_1" FOREIGN KEY ("target_id") REFERENCES "target" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "mailing_list" ("target_id");
ALTER TABLE "mailing_list_membership" ADD CONSTRAINT "mailing_list_membership_list_id_ibfk" FOREIGN KEY ("list_id") REFERENCES "mailing_list" ("target_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "mailing_list_membership" ("list_id");
ALTER TABLE "mailing_list_membership" ADD CONSTRAINT "mailing_list_membership_user_id_ibfk" FOREIGN KEY ("user_id") REFERENCES "user" ("target_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "mailing_list_membership" ("user_id");
ALTER TABLE "message" ADD CONSTRAINT "message_ibfk_1" FOREIGN KEY ("application_id") REFERENCES "application" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "message" ("application_id");
ALTER TABLE "message" ADD CONSTRAINT "message_ibfk_2" FOREIGN KEY ("target_id") REFERENCES "target" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "message" ("target_id");
ALTER TABLE "message" ADD CONSTRAINT "message_ibfk_3" FOREIGN KEY ("mode_id") REFERENCES "mode" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "message" ("mode_id");
ALTER TABLE "message" ADD CONSTRAINT "message_ibfk_4" FOREIGN KEY ("plan_id") REFERENCES "plan" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "message" ("plan_id");
ALTER TABLE "message" ADD CONSTRAINT "message_ibfk_5" FOREIGN KEY ("priority_id") REFERENCES "priority" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "message" ("priority_id");
ALTER TABLE "message" ADD CONSTRAINT "message_ibfk_6" FOREIGN KEY ("incident_id") REFERENCES "incident" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "message" ("incident_id");
ALTER TABLE "message" ADD CONSTRAINT "message_ibfk_7" FOREIGN KEY ("plan_notification_id") REFERENCES "plan_notification" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "message" ("plan_notification_id");
ALTER TABLE "message" ADD CONSTRAINT "message_ibfk_8" FOREIGN KEY ("template_id") REFERENCES "template" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "message" ("template_id");
ALTER TABLE "message_changelog" ADD CONSTRAINT "message_changelog_ibfk_1" FOREIGN KEY ("message_id") REFERENCES "message" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "message_changelog" ("message_id");
ALTER TABLE "plan" ADD CONSTRAINT "plan_ibfk_1" FOREIGN KEY ("user_id") REFERENCES "user" ("target_id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "plan" ("user_id");
ALTER TABLE "plan" ADD CONSTRAINT "plan_ibfk_2" FOREIGN KEY ("team_id") REFERENCES "team" ("target_id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "plan" ("team_id");
ALTER TABLE "plan_active" ADD CONSTRAINT "plan_active_ibfk_1" FOREIGN KEY ("plan_id") REFERENCES "plan" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "plan_active" ("plan_id");
ALTER TABLE "plan_notification" ADD CONSTRAINT "plan_notification_ibfk_1" FOREIGN KEY ("plan_id") REFERENCES "plan" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "plan_notification" ("plan_id");
ALTER TABLE "plan_notification" ADD CONSTRAINT "plan_notification_ibfk_2" FOREIGN KEY ("template") REFERENCES "template_active" ("name") ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "plan_notification" ("template");
ALTER TABLE "plan_notification" ADD CONSTRAINT "plan_notification_ibfk_3" FOREIGN KEY ("target_id") REFERENCES "target" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "plan_notification" ("target_id");
ALTER TABLE "plan_notification" ADD CONSTRAINT "plan_notification_ibfk_4" FOREIGN KEY ("role_id") REFERENCES "target_role" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "plan_notification" ("role_id");
ALTER TABLE "plan_notification" ADD CONSTRAINT "plan_notification_ibfk_5" FOREIGN KEY ("priority_id") REFERENCES "priority" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "plan_notification" ("priority_id");
ALTER TABLE "priority" ADD CONSTRAINT "priority_ibfk_1" FOREIGN KEY ("mode_id") REFERENCES "mode" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "priority" ("mode_id");
ALTER TABLE "response" ADD CONSTRAINT "response_ibfk_1" FOREIGN KEY ("message_id") REFERENCES "message" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "response" ("message_id");
ALTER TABLE "target" ADD CONSTRAINT "target_ibfk_1" FOREIGN KEY ("type_id") REFERENCES "target_type" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target" ("type_id");
ALTER TABLE "target_application_mode" ADD CONSTRAINT "target_application_mode_ibfk_1" FOREIGN KEY ("target_id") REFERENCES "target" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_application_mode" ("target_id");
ALTER TABLE "target_application_mode" ADD CONSTRAINT "target_application_mode_ibfk_2" FOREIGN KEY ("application_id") REFERENCES "application" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_application_mode" ("application_id");
ALTER TABLE "target_application_mode" ADD CONSTRAINT "target_application_mode_ibfk_3" FOREIGN KEY ("priority_id") REFERENCES "priority" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_application_mode" ("priority_id");
ALTER TABLE "target_application_mode" ADD CONSTRAINT "target_application_mode_ibfk_4" FOREIGN KEY ("mode_id") REFERENCES "mode" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_application_mode" ("mode_id");
ALTER TABLE "target_contact" ADD CONSTRAINT "target_contact_ibfk_1" FOREIGN KEY ("target_id") REFERENCES "target" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_contact" ("target_id");
ALTER TABLE "target_contact" ADD CONSTRAINT "target_contact_ibfk_2" FOREIGN KEY ("mode_id") REFERENCES "mode" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_contact" ("mode_id");
ALTER TABLE "target_mode" ADD CONSTRAINT "target_mode_ibfk_1" FOREIGN KEY ("target_id") REFERENCES "target" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_mode" ("target_id");
ALTER TABLE "target_mode" ADD CONSTRAINT "target_mode_ibfk_2" FOREIGN KEY ("priority_id") REFERENCES "priority" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_mode" ("priority_id");
ALTER TABLE "target_mode" ADD CONSTRAINT "target_mode_ibfk_3" FOREIGN KEY ("mode_id") REFERENCES "mode" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_mode" ("mode_id");
ALTER TABLE "target_reprioritization" ADD CONSTRAINT "target_reprioritization_mode_dst_mode_id_fk" FOREIGN KEY ("dst_mode_id") REFERENCES "mode" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_reprioritization" ("dst_mode_id");
ALTER TABLE "target_reprioritization" ADD CONSTRAINT "target_reprioritization_mode_src_mode_id_fk" FOREIGN KEY ("src_mode_id") REFERENCES "mode" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_reprioritization" ("src_mode_id");
ALTER TABLE "target_reprioritization" ADD CONSTRAINT "target_reprioritization_target_id_fk" FOREIGN KEY ("target_id") REFERENCES "target" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_reprioritization" ("target_id");
ALTER TABLE "target_role" ADD CONSTRAINT "target_role_ibfk_1" FOREIGN KEY ("type_id") REFERENCES "target_type" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "target_role" ("type_id");
ALTER TABLE "team" ADD CONSTRAINT "team_ibfk_1" FOREIGN KEY ("target_id") REFERENCES "target" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "team" ("target_id");
ALTER TABLE "team" ADD CONSTRAINT "team_ibfk_2" FOREIGN KEY ("manager_id") REFERENCES "user" ("target_id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "team" ("manager_id");
ALTER TABLE "team" ADD CONSTRAINT "team_ibfk_3" FOREIGN KEY ("director_id") REFERENCES "user" ("target_id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "team" ("director_id");
ALTER TABLE "template" ADD CONSTRAINT "template_ibfk_1" FOREIGN KEY ("user_id") REFERENCES "user" ("target_id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "template" ("user_id");
ALTER TABLE "template_active" ADD CONSTRAINT "template_active_ibfk_1" FOREIGN KEY ("template_id") REFERENCES "template" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "template_active" ("template_id");
ALTER TABLE "template_content" ADD CONSTRAINT "template_content_ibfk_1" FOREIGN KEY ("template_id") REFERENCES "template" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "template_content" ("template_id");
ALTER TABLE "template_content" ADD CONSTRAINT "template_content_ibfk_2" FOREIGN KEY ("application_id") REFERENCES "application" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "template_content" ("application_id");
ALTER TABLE "template_content" ADD CONSTRAINT "template_content_ibfk_3" FOREIGN KEY ("mode_id") REFERENCES "mode" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "template_content" ("mode_id");
ALTER TABLE "template_variable" ADD CONSTRAINT "template_variable_ibfk_1" FOREIGN KEY ("application_id") REFERENCES "application" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "template_variable" ("application_id");
ALTER TABLE "twilio_delivery_status" ADD CONSTRAINT "twilio_delivery_status_message_id_ibfk" FOREIGN KEY ("message_id") REFERENCES "message" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "twilio_delivery_status" ("message_id");
ALTER TABLE "twilio_retry" ADD CONSTRAINT "twilio_retry_message_id_ibfk" FOREIGN KEY ("message_id") REFERENCES "message" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "twilio_retry" ("message_id");
ALTER TABLE "twilio_retry" ADD CONSTRAINT "twilio_retry_retry_id_ibfk" FOREIGN KEY ("message_id") REFERENCES "message" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "twilio_retry" ("message_id");
ALTER TABLE "user" ADD CONSTRAINT "user_ibfk_1" FOREIGN KEY ("target_id") REFERENCES "target" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "user" ("target_id");
ALTER TABLE "user_setting" ADD CONSTRAINT "user_setting_ibfk_1" FOREIGN KEY ("user_id") REFERENCES "target" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "user_setting" ("user_id");
ALTER TABLE "user_team" ADD CONSTRAINT "user_team_ibfk_1" FOREIGN KEY ("user_id") REFERENCES "user" ("target_id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "user_team" ("user_id");
ALTER TABLE "user_team" ADD CONSTRAINT "user_team_ibfk_2" FOREIGN KEY ("team_id") REFERENCES "team" ("target_id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX ON "user_team" ("team_id");

-- Sequences --
CREATE SEQUENCE application_id_seq;
SELECT setval('application_id_seq', max(id)) FROM application;
ALTER TABLE "application" ALTER COLUMN "id" SET DEFAULT nextval('application_id_seq');
CREATE SEQUENCE device_id_seq;
SELECT setval('device_id_seq', max(id)) FROM device;
ALTER TABLE "device" ALTER COLUMN "id" SET DEFAULT nextval('device_id_seq');
CREATE SEQUENCE incident_id_seq;
SELECT setval('incident_id_seq', max(id)) FROM incident;
ALTER TABLE "incident" ALTER COLUMN "id" SET DEFAULT nextval('incident_id_seq');
CREATE SEQUENCE message_id_seq;
SELECT setval('message_id_seq', max(id)) FROM message;
ALTER TABLE "message" ALTER COLUMN "id" SET DEFAULT nextval('message_id_seq');
CREATE SEQUENCE message_changelog_id_seq;
SELECT setval('message_changelog_id_seq', max(id)) FROM message_changelog;
ALTER TABLE "message_changelog" ALTER COLUMN "id" SET DEFAULT nextval('message_changelog_id_seq');
CREATE SEQUENCE mode_id_seq;
SELECT setval('mode_id_seq', max(id)) FROM mode;
ALTER TABLE "mode" ALTER COLUMN "id" SET DEFAULT nextval('mode_id_seq');
CREATE SEQUENCE plan_id_seq;
SELECT setval('plan_id_seq', max(id)) FROM plan;
ALTER TABLE "plan" ALTER COLUMN "id" SET DEFAULT nextval('plan_id_seq');
CREATE SEQUENCE plan_notification_id_seq;
SELECT setval('plan_notification_id_seq', max(id)) FROM plan_notification;
ALTER TABLE "plan_notification" ALTER COLUMN "id" SET DEFAULT nextval('plan_notification_id_seq');
CREATE SEQUENCE priority_id_seq;
SELECT setval('priority_id_seq', max(id)) FROM priority;
ALTER TABLE "priority" ALTER COLUMN "id" SET DEFAULT nextval('priority_id_seq');
CREATE SEQUENCE response_id_seq;
SELECT setval('response_id_seq', max(id)) FROM response;
ALTER TABLE "response" ALTER COLUMN "id" SET DEFAULT nextval('response_id_seq');
CREATE SEQUENCE target_id_seq;
SELECT setval('target_id_seq', max(id)) FROM target;
ALTER TABLE "target" ALTER COLUMN "id" SET DEFAULT nextval('target_id_seq');
CREATE SEQUENCE target_role_id_seq;
SELECT setval('target_role_id_seq', max(id)) FROM target_role;
ALTER TABLE "target_role" ALTER COLUMN "id" SET DEFAULT nextval('target_role_id_seq');
CREATE SEQUENCE target_type_id_seq;
SELECT setval('target_type_id_seq', max(id)) FROM target_type;
ALTER TABLE "target_type" ALTER COLUMN "id" SET DEFAULT nextval('target_type_id_seq');
CREATE SEQUENCE template_id_seq;
SELECT setval('template_id_seq', max(id)) FROM template;
ALTER TABLE "template" ALTER COLUMN "id" SET DEFAULT nextval('template_id_seq');
CREATE SEQUENCE template_variable_id_seq;
SELECT setval('template_variable_id_seq', max(id)) FROM template_variable;
ALTER TABLE "template_variable" ALTER COLUMN "id" SET DEFAULT nextval('template_variable_id_seq');

-- Full Text keys --

COMMIT;
