

import psycopg2
#from config import config

conn = None

# put details in secrets
conn = psycopg2.connect(
    database="wozdb",
    user="postgres",
    password="password",
    host="woznet-db.cdi80wpde4wf.us-east-1.rds.amazonaws.com",
    port="5432"
)

# create a cursor. What does that mean?
cur = conn.cursor()

## execute a statement
#print('PostgreSQL database version:')
#cur.execute('SELECT version()')

## display the PostgreSQL database server version
#db_version = cur.fetchone()
#print(db_version)

sql = "INSERT INTO lambda(id, created, request, type, status) VALUES('08351451-6bfd-4c14-8bc2-1ad906a76952', '2022-01-05 13:50', 'do this', 'reset', 'new')"

cur.execute(sql)
conn.commit()

# close the communication with the PostgreSQL
cur.close()

if conn is not None:
  conn.close()
  print('Database connection closed.')


