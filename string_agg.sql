Dataset : 
  
drop table emp_input;
create table emp_input
(
id      int,
name    varchar(40)
);
insert into emp_input values (1, 'Emp1');
insert into emp_input values (2, 'Emp2');
insert into emp_input values (3, 'Emp3');
insert into emp_input values (4, 'Emp4');
insert into emp_input values (5, 'Emp5');
insert into emp_input values (6, 'Emp6');
insert into emp_input values (7, 'Emp7');
insert into emp_input values (8, 'Emp8');

select * from emp_input;


Solution : 
  
with cte as
    (select concat(id, ' ', name) as name
    , ntile(4) over(order by id) as buckets
    from emp_input)
select group_concat(name) as final_result
from cte
group by buckets
order by 1



