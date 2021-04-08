CREATE SEQUENCE "Task_id_seq";
DROP TABLE IF EXISTS "Task";
CREATE TABLE "Task" (
                        "id" int8 NOT NULL DEFAULT nextval('"User_id_seq"'::regclass),
                        "userId" int8 NOT NULL,
                        "title" varchar(255) NOT NULL,
                        "text" TEXT DEFAULT NULL,
                        PRIMARY KEY("id"),
                        CONSTRAINT fk_user
                            FOREIGN KEY("userId")
                            REFERENCES "User"("id")
                            ON DELETE CASCADE
);
