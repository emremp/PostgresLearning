/*
CREATE DATABASE name
    [ [ WITH ] [ OWNER [=] user_name ]
           [ TEMPLATE [=] template ]
           [ ENCODING [=] encoding ]
           [ LC_COLLATE [=] lc_collate ]
           [ LC_CTYPE [=] lc_ctype ]
           [ TABLESPACE [=] tablespace ]
           [ CONNECTION LIMIT [=] connlimit ] ]*/

-- https://stackoverflow.com/questions/18389124/simulate-create-database-if-not-exists-for-postgresql
-- CREATE DATABASE cannot be executed inside a transaction block.
-- You need to install the additional module dblink (once per db):


-- https://stackoverflow.com/questions/3862648/how-to-use-install-dblink-in-postgresql/13264961#13264961

-- With PostgreSQL 9.1 or later, installation of additional modules has been simplified. Registered extensions (including dblink) can be installed with CREATE EXTENSION:
SELECT version()

-- CREATE EXTENSION dblink;

-- SELECT pg_namespace.nspname, pg_proc.proname
-- FROM pg_proc, pg_namespace
-- WHERE pg_proc.pronamespace=pg_namespace.oid
--    AND pg_proc.proname LIKE '%dblink%';

-- https://stackoverflow.com/questions/18389124/simulate-create-database-if-not-exists-for-postgresql/36218838#36218838
DO
$do$
DECLARE
  _db TEXT := 'some_db';
  _user TEXT := 'admin';
  _password TEXT := 'sd33d12dsad';
BEGIN
  CREATE EXTENSION IF NOT EXISTS dblink; -- enable extension
  IF EXISTS (SELECT 1 FROM pg_database WHERE datname = _db) THEN
    RAISE NOTICE 'Database already exists';
  ELSE
    PERFORM dblink_connect('host=localhost user=' || _user || ' password=' || _password || ' dbname=' || current_database());
    PERFORM dblink_exec('CREATE DATABASE ' || _db);
  END IF;
END
$do$