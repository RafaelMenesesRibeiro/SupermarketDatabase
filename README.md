# SupermarketDatabaseExample

[University Project]

[3rd Year - 1st Semester]

Objective:
- Learn how to create a database
- Learn PHP and mySQL
- Learn how to use PHP to access and control a database

###### Creating and testing the database:

**1) Open two ssh session to the machine where your database is being stored, insert required credentials**
```
ssh stXXXXXX@sigma.ist.utl.pt:~
```
**2) From the directory where your SQL files are stored, push them into the server**
```
scp *.sql istXXXXXX@sigma.ist.utl.pt:~
```
**3) On one of the recently opened remote sessions, initiate a PSQL session**
```
psql -h db.ist.utl.pt -U istXXXXXX
```
**4) Create the database tables and populate them using the two following commands**
```
\i schema.sql
\i populate.sql
```
**5) Test your queries**
```
\i queries.sql
```

**6) The following list of commands work as "scripts" for quick deletation, printing, etc...**
```
List all tables from current schema (not their entries): \dt
List all tables and their entries from current schema: \i listtables.sql
Delete all tables from current schema: \i droptables.sql
```
