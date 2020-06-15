CREATE TABLE "public"."playlist"("uri" text NOT NULL, "title" text NOT NULL, "description" text, "id" serial NOT NULL, "user_id" text, "created_at" timestamp NOT NULL DEFAULT now(), PRIMARY KEY ("id") , UNIQUE ("uri"));