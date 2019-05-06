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