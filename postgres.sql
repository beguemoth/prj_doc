select current_date;

for client apps:
PGHOST
PGPORT
-------
createdb <dbname>
dropdb <dbname>


select version();
select current_time;

psql
\h --help
\q --quit


\i sqlfile.sql --runs script


-------datatypes
varchar(10)
int
real
date  ---'2019-01-31'

point  -- '(-1.34, 45.21)'

copy table_name from /home/user/data.txt;

----
? what are schemas in postgres?

seleect a,b, max(c) from x goup by a, b having max(c)>2;

------
begin;
update ...
savepoint sp1;
insert ...
...
rollback to savepoint sp1;
...

if ... then
rollback;
end if;

commit;




