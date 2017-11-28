# Supermarket_db
## Databases course project, 3rd delivery

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

**6) The following list of commands can be used to reset/print your entire database, they will be scripted soon**
```
drop table categoria cascade;
drop table categoria_simples cascade;
drop table super_categoria cascade;
drop table constituida cascade;
drop table produto cascade;
drop table fornecedor cascade;
drop table fornece_sec cascade;
drop table corredor cascade;
drop table prateleira cascade;
drop table planograma cascade;
drop table evento_reposicao cascade;
drop table reposicao cascade;
```

```
select * from categoria;
select * from categoria_simples;
select * from super_categoria;
select * from constituida;
select * from produto;
select * from fornecedor;
select * from fornece_sec;
select * from corredor;
select * from prateleira;
select * from planograma;
select * from evento_reposicao;
select * from reposicao;
```
