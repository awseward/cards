import junk_drawer/db
import os
import db_postgres

export db
export db_postgres

let postgresUrl = getEnv "DATABASE_URL"

proc open_pg*(): db_postgres.DbConn =
  db_postgres.open("", "", "", postgresUrl)
