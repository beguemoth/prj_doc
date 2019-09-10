set serveroutput on
/
exec dbms_output.put_line('start test')
/
create or replace procedure my_line
is
begin
	dbms_output.put_line('----------------');
end;
/
declare
	a number(10,2) := 100.123;
	b number := 123.45678;
	c number(4) := 321.1;
begin
	my_line;
	dbms_output.put_line(a);
	a := a + 1;
	dbms_output.put_line(a);
	dbms_output.put_line(b);
	dbms_output.put_line(c);
	my_line;
end;
/
exec my_line
/
create or replace package pkg_1
is
type tbl_idx is table of varchar2(10) index by binary_integer;
v_tbl_1 tbl_idx;
procedure proc_1;
end pkg_1;
/
show errors
create or replace package body pkg_1
is
	v_clob clob;
	procedure proc_1
	is
	begin
		v_tbl_1(2) := 'Element 2';
		v_clob := 'procedure pkg_1.proc_1 called';
		dbms_output.put_line(v_clob || ' ' || v_tbl_1(2));
		dbms_output.put_line(v_tbl_1(1));
	exception
		when others then
			dbms_output.put_line('Error message: ' || sqlerrm);
			dbms_output.put_line('Error code: ' || sqlcode);
	end;
end pkg_1;
/
show errors
exec pkg_1.proc_1
/
show errors
create or replace package pkg_pipelined
is
type pipe_record is record(
	id number(10),
	txt clob
);
type pipe_table is table of pipe_record;
type t_cur is ref cursor return dba_users%rowtype;
function f_pipe(x number) return pipe_table pipelined;
function f_db_pipe(p_cur t_cur) return pipe_table pipelined; 
end pkg_pipelined;
/
show errors
create or replace package body pkg_pipelined
is
function f_pipe(x number) return pipe_table pipelined
is
v_rec pipe_record;
begin
v_rec.id := 1;
v_rec.txt := 'Odyn';
pipe row(v_rec);
v_rec.id := 2;
v_rec.txt := 'Dva';
pipe row(v_rec);
end;

function f_db_pipe(p_cur t_cur) return pipe_table pipelined
is
v_rec pipe_record;
v_cur DBA_USERS%rowtype;
begin
--open p_cur; -- for (select * from DBA_USERS);
loop
fetch p_cur into v_cur;
exit when p_cur%notfound;
v_rec.id := v_cur.user_id;
v_rec.txt:= to_char(v_cur.user_id+1)||' **';
pipe row(v_rec);
end loop;
end;

end pkg_pipelined;
/
show errors
--select * from table(pkg_pipelined.f_db_pipe(cursor(select * from dba_users)));

--Libraries in PL/SQL ???
/*
ALL_PLSQL_OBJECT_SETTINGS:
 PLSQL_CCFLAGS Lets you control conditional compilation of each PL/SQL unit
independently.
*/
--scopes and labels
<<outer>>
declare
	v_x varchar2(10) := 'Outer';
	begin
		declare v_x varchar2(10) := 'Inner';
		begin
		dbms_output.put_line(v_x);
		dbms_output.put_line(outer.v_x);
		end;
	end;
/
show errors
create or replace function outer(p_x number) return boolean
is
v_x char(10) := 'outer';
	function inner(p_x number) return boolean
	is
	v_x char(10) := 'inner';
	begin
		dbms_output.put_line(outer.v_x);
		dbms_output.put_line(v_x);
		return true;
	end;
begin
return inner(p_x);
end; 
/
show errors
declare
	v_x boolean;
begin
v_x := outer(100);
end;
/
show errors