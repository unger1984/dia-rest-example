CREATE SEQUENCE "User_id_seq";
DROP TABLE IF EXISTS "User";
CREATE TABLE "User" (
                        "id" int8 NOT NULL DEFAULT nextval('"User_id_seq"'::regclass),
                                   "name" varchar(255) NOT NULL,
                                   "login" varchar(255) NOT NULL UNIQUE,
                                   "password" varchar(255) NOT NULL
);
ALTER TABLE "User" ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");

INSERT INTO "User" ("name","login","password") VALUES ('Test User', 'test','test');
