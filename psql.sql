-- decimal(x,y) --type
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
