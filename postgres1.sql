--select * from test;
/*
create table testx(
id bigint,
txt varchar(10),
val numeric(10,2),
a int);

alter table testx add constraint testx_pk primary key(id);
*/
--alter table testx add constraint testx_txt not null(txt);

/*
insert into testx(id, txt, val, a)
values(1, '111', 1.1, 1);
insert into testx(id, txt, val, a)
values(2, '222', 2.2, 2);
insert into testx(id, txt, val, a)
values(3, '333', 3.3, 3);
*/

--select * from testx;
--select id, sum(id) over () from testx;

--select id, sum(id) over (order by id) from testx;
/*
insert into testx (id,txt,val, a)
values(10,'101', 10.1,1);
*/

/*
begin; --same as start transaction command
insert into testx (id,txt,val, a)
values(20,'200', 20.0,2);

insert into testx (id,txt,val, a)
values(21,'201', 20.1,2);

insert into testx (id,txt,val, a)
values(30,'300', 30.0,3);
commit;
*/

