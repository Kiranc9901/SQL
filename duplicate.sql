drop table if exists cars;
create table if not exists cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);

insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);

 --  <<<<>>>> Scenario 1: Data duplicated based on SOME of the columns <<<<>>>>

-- solution 1: delete using a unique identifier

DELETE FROM cars
WHERE id IN (
    SELECT id FROM (
        SELECT MAX(id) AS id
        FROM cars
        GROUP BY model, brand
        HAVING COUNT(*) > 1
    ) AS t
);
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

-- solution 2: delete using self join 
DELETE FROM cars
WHERE id IN (
    SELECT id FROM (
        SELECT c2.id
        FROM cars c1
        JOIN cars c2 ON c1.model = c2.model AND c1.brand = c2.brand
        WHERE c1.id < c2.id
    ) AS t
);


-- solution 3: using window function
delete from cars
where id in 
(
select id from (
		select * 
		, row_number() over(partition by model,brand) rn
		from cars) x 
where x.rn >1  ); 


-- Solution 4: using the min function. This deletes even multiple duplicate records



DELETE FROM cars
WHERE id NOT IN (
    SELECT id FROM (
        SELECT MIN(id) AS id
        FROM cars
        GROUP BY model, brand
    ) AS t
);

-- SOLUTION 5: Using a backup table.

drop table if exists cars_bkp;
create table if not exists cars_bkp
as
select * from cars where 1=0;

insert into cars_bkp
select * from cars
where id in ( select min(id)
              from cars
              group by model, brand);

drop table cars;
alter table cars_bkp rename to cars;

-- SOLUTION 6: Using a backup table without dropping the original table.


drop table if exists cars_bkp;
create table if not exists cars_bkp
as
select * from cars where 1=0;

insert into cars_bkp
select * from cars
where id in ( select min(id)
              from cars
              group by model, brand);

truncate table cars;

insert into cars
select * from cars_bkp;

drop table cars_bkp;



