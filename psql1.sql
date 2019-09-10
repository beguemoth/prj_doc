-- decimal(x,y) --type
/*
create role <name> password 'pwd';
drop role <name>
drop owned by <role>;

select rolname from pg_roles;

\du   --psql - lists roles

create role <name> login;
same as
create user <name>;

create role <name> superuser;
create role <name> createdb; --permission to create db
create role <name> createrole;
create role <name> login replication;

--group creation:
create role <group>
grant <group> to <user1>, <user2> ...
revoke <group> from <user1>, ..

create role <group1>
grant <group> to <group1>

set role <group> --? sets your group role current

create <user> login inherit | noinherit
grant <group> to <user> --<group> permissions will be inherited by <user>

alter table <table> owner to <user>;

posgreSQL has some predefined roles, e.g. pg_monitor.

select datname from pg_database;

create database <dbname> [owner <role>] --copies from template1
create database <dbname> template <template0>
drop database <dbname>

initdb --locale=ru_RU
CREATE TABLE test1 (
a text COLLATE "de_DE",
b text COLLATE "es_ES",
...
);

OS
initdb ---???
createdb <dbname>
dropdb <dbname>

pg_dump; --??? 

pg_database.datallowconn --this flag (if true) allows to connect to this DB

create tablespace <tbsname> location '/home/user/,,,' -- the directory must exist and belong to OS user who runs postgreSQL
drop tablespace <tbsname>

select spcname from pg_tablespace;
\db -- the same

create table ... tablespace <tbsname>

--default tablespaces:
pg_global --for system directories
pg_default --for user tables

*/  

--Ist das angenehm?
--Ist das schwer?
--Ist das nützlich?
--Das ist langweilig.

/*
Ich brauche Geduld.
Ich brauche Liebe und Sorge.
Ich brauche Aufmerksamkeit.
Ich brauche acht Prozent Gewinn.

Ende gut, alles gut.
Geduld bringt Rosen.
Übипg macht den Meister.
Ohne Fleiß kein Preis.

Wie geht es Ihnen?
Как поживаете?
Danke, es geht mir gut!
Как дела?
Danke, es geht!

Jede Woche hat sieben Tage.
Sie heißen:
Montag, Dienstag, Mittwoch, Donnerstag,
Freitag, Samstag (oder Sonnabend), Sonntag.
*/

/*
vacuum --updates and deletes do not free space immediatelly...
vacuum full --cannot be run in parallel with queries an updates

? analyze ?
? parameter track_counts ? if true, autoclean is on. It is on by default.
*/
reindex table employee;


/*
begin;
insert into test values(5, '5 text');
savepoint sp1;
insert into test values(500, '500 test');
rollback to sp1;
commit;
*/

select id, dep_name, salary, avg(salary) over (partition by dep_name)
from employee;

select id, dep_name, salary, rank() over (order by salary desc)
from employee; 

select id, dep_name, salary, dense_rank() over (order by salary desc)
from employee;


select salary, sum(salary) over (order by salary)
from employee;

-----??????????
select sum(salary) over w, avg(salary) over w
from employee
window w as (partition by dep_name order by salary);

/*
create table t1(a int);
create table t2(b text) inherits t1;
select * from ONLY t1 where a>2;
*/

select real '1.23';
select 1.23::real;
select cast('1.23' as real);

--??? returns one row ONLY! ????
/*
create function func_employe(text)
    returns employee
as
    $$
    select * from employee
	where dep_name = $1
    $$
language sql;   
*/

select array_agg(distinct dep_name order by dep_name asc) from employee;
select string_agg(dep_name, ', ' order by dep_name asc) from employee;

/*
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY income) FROM households;
*/

select count(*) as a,
	count(*) filter (where salary > 100) as b
from employee;


/*
rows between ...
UNBOUNDED PRECEDING
смещение PRECEDING
CURRENT ROW
смещение FOLLOWING
UNBOUNDED FOLLOWING
EXCLUDE CURRENT ROW
*/


--What is collate rule C fo UTF-8 ??
select * from employee order by dep_name collate "C";


select array[1,2,3+4];
select array[1,2.3,2.6]::int[];
select array[[1,2],[3,4]];
select '{{1,2},{3,4}}'::int[];
--arrays must have type:
select '{}'::int[];

select array(select id from employee);

select ROW(id) from employee; ----???????????
select row(1,2,10,'23');

--------------
/*
CREATE FUNCTION concat_lower_or_upper(a text, b text,
uppercase boolean DEFAULT false)
RETURNS text
AS
$$
SELECT CASE
WHEN $3 THEN UPPER($1 || ' ' || $2)
ELSE LOWER($1 || ' ' || $2)
END;
$$
LANGUAGE SQL IMMUTABLE STRICT;
*/
select concat_lower_or_upper(a=>'one', b=>'two');

select id,
case 
	when id>3 then 10/2
	when id<3 then 10/3
	--each value in THEN CLAUSE is evaluated even if WHEN value does not match !
	--when id>100 then 10/0
	else 10/4
end as "my field"
from employee;
	
/*
create table tb1(
id bigint default nextval('my_sequence'),
txt text default 'def txt',
x bigint references tb2(id2) on delete restrict | cascade,
y bigint references tb3(id3) on update restrict | cascade,
a int constraint my_check_name check(a>0),
b int,
constraint check_2 check (a>b),
unique(a,b)
...
)
WITH OIDS;

alter table employee add column col1 text;
alter table employee drop column col1 cascade;
alter table employee alter column col1 set default '123';
alter table employee alter column col1 drop default;
alter table employee alter column col1 type numeric(10,3);
alter table emp rename column col1 to col2;
alter table emp rename to emp2;

alter table emp enable row level secuity; 

pg_dump <dbname> > file_name --?? does not work ??--
*/

/*
CREATE TABLE accounts (manager text, company text, contact_email text);
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY account_managers ON accounts TO managers --managers group
	USING (manager = current_user);

create policy select_policy on users --all users may see
	using (true);
CREATE POLICY modify_policy ON users --only one user may modify
	USING (user_name = current_user);
*/
select tableoid, --table id
	xmin, --transaction id that added row
	cmin, --command id of transaction
	xmax, --tran id that deleted row
	cmax, --cmd id of xmax
	id,
	dep_name from employee;

select relname,
	relnamespace,
	reltype,
	reloftype,
	relowner
 from pg_class limit 1;

--create role my_role_1;
select rolname from pg_roles;


