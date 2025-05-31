-- part 1 JOIN

select 
	SUM(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd ;

select 
	-- fa.adset_name ,
	SUM(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd 
inner join public.facebook_adset fa on fabd.adset_id = fa.adset_id 
-- group by fa.adset_name ;

select 
	-- fa.adset_name ,
	SUM(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd 
inner join public."OS_facebook_adset_test" fa on fabd.adset_id = fa.adset_id
-- дані втрачено
;


select 
	fa.adset_name ,
	SUM(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd 
left join public."OS_facebook_adset_test" fa on fabd.adset_id = fa.adset_id
group by fa.adset_name 
;

select 
	-- fa.adset_name ,
	SUM(fabd.spend) as spend
from public."OS_facebook_adset_test" fa
right join public.facebook_ads_basic_daily fabd on fabd.adset_id = fa.adset_id
;

select 
	-- fa.adset_name ,
	SUM(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd 
left join public.facebook_adset fa on fabd.adset_id = fa.adset_id 
-- group by fa.adset_name ;
;

select *
from public."OS_facebook_adset_test" fa
right join public.facebook_ads_basic_daily fabd on fabd.adset_id = fa.adset_id
where fa.adset_id is null
;

select 
	sum(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd 
left join public."OS_facebook_adset_test" fa on fabd.adset_id = fa.adset_id 
where fa.adset_id is null
;

select 
	* -- sum(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd 
full join public."OS_facebook_adset_test" fa on fabd.adset_id = fa.adset_id 
left join public.facebook_campaign fc on fabd.campaign_id = fc.campaign_id 
where fa.adset_id is null or fabd.adset_id is null
;


select 
	list.campaign_name,
	list.adset_name,
	sum(fabd.spend) as spend,
	sum(fabd.value) as value
from public.facebook_ads_basic_daily fabd 
inner join
(
	select *
	from
	(
		select *
		from facebook_adset fa 
		limit 10
	) ads
	cross join
	(
		select *
		from facebook_campaign fc 
		limit 3
	) c
) list on fabd.campaign_id = list.campaign_id and fabd.adset_id = list.adset_id
group by list.campaign_name, list.adset_name
;

with list_table as
(	select *
	from
	(
		select *
		from facebook_adset fa 
		limit 10
	) ads
	cross join
	(
		select *
		from facebook_campaign fc 
		limit 3
	) c
)
select 
	list.campaign_name,
	list.adset_name,
	sum(fabd.spend) as spend 
from public.facebook_ads_basic_daily fabd 
inner join list_table list on fabd.campaign_id = list.campaign_id and fabd.adset_id = list.adset_id
group by list.campaign_name, list.adset_name
;

select 
	fa.adset_name,
	sum(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd 
full join public."OS_facebook_adset_test" fa on fabd.adset_id = fa.adset_id 
group by 1
;


-- test --

select 
	sum(value)
from public.facebook_ads_basic_daily stat
inner join public.facebook_adset ads
	on stat.adset_id = ads.adset_id ;

select *
from public.facebook_ads_basic_daily stat
full join public."OS_facebook_adset_test" ads
	on stat.adset_id = ads.adset_id 
where stat.adset_id is null or ads.adset_id is null ;

select 
	list.campaign_name,
	list.adset_name,
	SUM(spend) as spend
from public.facebook_ads_basic_daily stat
inner join 
(
select *
from 
	(
	select *
	from public.facebook_adset
	limit 10
	) ads
cross join 
	(
	select *
	from public.facebook_campaign fc 
	limit 10
	) cam 
) list on list.adset_id = stat.adset_id and list.campaign_id = stat.campaign_id 
group by 1,2;


with list as
(
select *
from 
	(
	select *
	from public.facebook_adset
	limit 10
	) ads
cross join 
	(
	select *
	from public.facebook_campaign fc 
	limit 10
	) cam
)
select 
	l.campaign_name,
	l.adset_name,
	SUM(spend) as spend
from public.facebook_ads_basic_daily stat
inner join list l on l.adset_id = stat.adset_id and l.campaign_id = stat.campaign_id 
group by 1,2;





-- part 2 CREATE - Щоб створити нову сутність
drop table OS_test_table;
create table if not exists OS_test_table (
	id INT primary key,
	name  varchar(255), -- text
	age INT
);

select * from OS_test_table;

create table if not exists OS_test_table_select as
select 
	fa.adset_name,
	sum(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd 
full join public."OS_facebook_adset_test" fa on fabd.adset_id = fa.adset_id 
group by 1
;

select * from OS_test_table_select;

create table if not exists OS_test_table_select1 as
with list_table as
(	select *
	from
	(
		select *
		from facebook_adset fa 
		limit 10
	) ads
	cross join
	(
		select *
		from facebook_campaign fc 
		limit 3
	) c
)
select 
	list.campaign_name,
	list.adset_name,
	sum(fabd.spend) as spend 
from public.facebook_ads_basic_daily fabd 
inner join list_table list on fabd.campaign_id = list.campaign_id and fabd.adset_id = list.adset_id
group by list.campaign_name, list.adset_name
;

select * from OS_test_table_select1;


CREATE table if not EXISTS public.OS_test_table2(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);



select * from OS_test_table;

CREATE table if not EXISTS OS_test_table1 as
with list as
(
select *
from 
	(
	select *
	from public.facebook_adset
	limit 10
	) ads
cross join 
	(
	select *
	from public.facebook_campaign fc 
	limit 10
	) cam
)
select 
	l.campaign_name,
	l.adset_name,
	SUM(spend) as spend
from public.facebook_ads_basic_daily stat
inner join list l on l.adset_id = stat.adset_id and l.campaign_id = stat.campaign_id 
group by 1,2
;

select * from OS_test_table1;


-- drop table public."OS_friends";
-- drop view os_friends_stat;
-- drop MATERIALIZED VIEW os_friends_stat_m ;


select * 
from public."OS_friends"
;


create view public.os_friends_view as
select 
	f."Season",
	COUNT(f."Episode_Title") as num_e,
	SUM(f."Duration") as duration
from public."OS_friends" f
group by 1;

create materialized view public.os_friends_mview as
select 
	f."Season",
	COUNT(f."Episode_Title") as num_e,
	SUM(f."Duration") as duration
from public."OS_friends" f
group by 1;

REFRESH MATERIALIZED VIEW os_friends_mview;



create view os_friends_stat as
select 
	"Season",
	"Year_of_prod",
	COUNT( "Episode Number") as num_ep,
	SUM("Duration") as total_duration,
	MIN("Stars") as min_stars,
	MAx("Stars") as max_stars
from public."OS_friends"
group by 1,2;

create MATERIALIZED VIEW os_friends_stat_m as
select 
	"Season",
	"Year_of_prod",
	COUNT( "Episode Number") as num_ep,
	SUM("Duration") as total_duration,
	MIN("Stars") as min_stars,
	MAx("Stars") as max_stars
from public."OS_friends"
group by 1,2;

REFRESH MATERIALIZED VIEW os_friends_stat_m;

-- part 2 INSERT - використовується для вставки (чи додавання) нових записів у таблицю бази даних. ТАБЛИЦІ

insert into OS_test_table
values (2, 'Olena',33);

select * from OS_test_table;


insert into OS_test_table_select
select
	fa.adset_name,
	sum(fabd.spend) as spend
from public.facebook_ads_basic_daily fabd 
left join public."OS_facebook_adset_test" fa on fabd.adset_id = fa.adset_id 
where fa.adset_id is null
group by 1
;

select * from OS_test_table_select;

insert into OS_test_table1
with list as
(
select *
from 
	(
	select *
	from public.facebook_adset
	limit 5
	) ads
cross join 
	(
	select *
	from public.facebook_campaign fc 
	limit 5
	) cam
)
select 
	l.campaign_name,
	l.adset_name,
	SUM(spend) as spend
from public.facebook_ads_basic_daily stat
inner join list l on l.adset_id = stat.adset_id and l.campaign_id = stat.campaign_id 
group by 1,2;



-- part 2 UPDATE - використовується для зміни вже наявних записів у таблиці бази даних. ТАБЛИЦІ

update OS_test_table_select
set adset_name = 'Unknown'
where adset_name is null;

update OS_test_table_select
set spend = 0
where adset_name = '9194252';

update OS_test_table_select
set spend = 0
where adset_name = '9194252' or adset_name = 'test';

select * from OS_test_table_select;


update OS_test_table
set id = 5
where id = 1;

select * from OS_test_table;

-- part 2 DELETE - використовується для видалення записів із таблиці бази даних.  ТАБЛИЦІ


delete from  OS_test_table_select
where adset_name = '9194252' or adset_name = 'test';

delete from OS_test_table_select
where spend < 1000;

select * from OS_test_table_select;

delete from OS_test_table
where id = 2;


ALTER TABLE OS_test_table_select_and_other
ADD COLUMN "to_del" INT;

update OS_test_table_select_and_other
set "to_del" = 1
where spend < 100000;

select * from OS_test_table_select_and_other
where "to_del" is null;

-- part 2 ALTER - використовується для зміни структури бази даних.  ТАБЛИЦІ

ALTER TABLE OS_test_table_select
ADD COLUMN "Romi" INT;

ALTER TABLE OS_test_table_select
ALTER COLUMN "Romi" TYPE numeric;

ALTER TABLE OS_test_table_select
DROP COLUMN "Romi";


-- part 2 RENAME - використовується для перейменування об’єкта.

ALTER TABLE OS_test_table_select
RENAME TO OS_test_table_select_and_other;

ALTER VIEW os_friends_view
RENAME TO os_friends_view_new;

ALTER MATERIALIZED VIEW os_friends_mview
RENAME TO os_friends_mview_new;

-- part 2 TRUNCATE - використовується для видалення всіх записів із таблиці.  ТАБЛИЦІ

truncate table OS_test_table_select_and_other;

select * from OS_test_table_select_and_other;

-- part 2 DROP - використовується для видалення об’єктів із бази даних.

drop table /*if exists */ OS_test_table_select_and_other;






















CREATE MATERIALIZED VIEW OS_monthly_emplo AS
SELECT
    EXTRACT(YEAR FROM e.hire_date) AS year_id,
    EXTRACT(MONTH FROM e.hire_date) AS month_id,
    COUNT(distinct e.employee_id) as num_new
FROM
    "HR".employees e
GROUP BY
    EXTRACT(YEAR FROM e.hire_date),
    EXTRACT(MONTH FROM e.hire_date);
    
REFRESH MATERIALIZED VIEW OS_monthly_emplo;
   
create VIEW OS_monthly_emplov1 AS
SELECT
    EXTRACT(YEAR FROM e.hire_date) AS year_id,
    EXTRACT(MONTH FROM e.hire_date) AS month_id,
    COUNT(distinct e.employee_id) as num_new
FROM
    "HR".employees e
GROUP BY
    EXTRACT(YEAR FROM e.hire_date),
    EXTRACT(MONTH FROM e.hire_date);
    
select * from OS_monthly_emplov1;