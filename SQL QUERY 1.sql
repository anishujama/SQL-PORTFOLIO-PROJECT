
--number of rows in our dataset1

select count(*) from dataset1
select count(*) from dataset2

--dataset for jharkhand and bihar
 
select *  from dataset1
where state in ('Bihar','Jharkhand')

--Total popolution of india

UPDATE dataset2
SET Population = REPLACE(population, ',', '');

ALTER TABLE dataset2
ALTER COLUMN population TYPE INTEGER
USING population::INTEGER;

select sum(population) population_of_india from dataset2

--Average growth of india
SELECT *
FROM dataset1
WHERE growth ILIKE 'growth%';

DELETE FROM dataset1
WHERE growth = 'Growth';

DELETE FROM dataset1
WHERE LOWER(growth) = 'growth';


ALTER TABLE dataset1
ALTER COLUMN growth TYPE double precision
USING growth::double precision;


select avg(growth) avg_growth_of_india from dataset1

--Average growth of particular state

select state, avg(growth) avg_growth_of_invidual_state from dataset1
group by state

--Average sex ratio of india

UPDATE dataset1
SET sex_ratio = REPLACE(sex_ratio, ',', '');

UPDATE dataset1
SET sex_ratio = NULL
WHERE sex_ratio IN ('NA', '-', 'Sex_Ratio', '');


ALTER TABLE dataset1
ALTER COLUMN sex_ratio TYPE DOUBLE PRECISION
USING NULLIF(sex_ratio,'')::DOUBLE PRECISION;


select avg(sex_ratio) avg_sex_ratio from dataset1

--Average sex ratio of particular state

select state, round(avg(sex_ratio)::numeric,0) avg_sex_ratio from dataset1 
group by state 
order by avg_sex_ratio desc

-- avg literacy rate of india

ALTER TABLE dataset1
ALTER COLUMN literacy TYPE double precision
USING literacy::double precision;

select avg(literacy) as avg_literacy from dataset1

-- avg literacy rate of individual_state

select state, round(avg(literacy)) as avg_literacy from dataset1
group by state
order by avg_literacy desc

-- top 3 state showing highest growth ratio

select state , round(avg(growth)*100) as  highest_growth from dataset1
group by state
order by highest_growth desc
limit 3


--bottom 3 state showing lowest sex ratio

select state , round(avg(sex_ratio)) as  lowest_sex_ratio from dataset1
group by state
order by lowest_sex_ratio asc
limit 3

-- top 3 states in literacy state
select state , round(avg(literacy)) as top3 from dataset1
group by state
order by top3 desc
limit 3

-- bottom 3 states in literacy state

select state , round(avg(literacy)) as bottom3 from dataset1
group by state
order by bottom3 asc
limit 3

-- top and bottom 3 states in literacy state in one place 
create table topstates
( state varchar(255),
  topstate float
  )
insert into topstates
select state,round(avg(literacy)) avg_literacy_ratio from dataset1 
group by state
order by avg_literacy_ratio desc
limit 3
select top 3 * from topstates order by topstates.topstate desc;


create table bottomstates
( state varchar(255),
  topstate float
  )
  
select * from topstates


insert into bottomstates
select state,round(avg(literacy)) avg_literacy_ratio from dataset1 
group by state
order by avg_literacy_ratio asc
limit 3

select * from bottomstates


SELECT state, top3 AS literacy
FROM
(select state , round(avg(literacy)) as top3 from dataset1
group by state
order by top3 desc
limit 3) as top_states
union all
SELECT state, bottom3 AS literacy
FROM 
(select state , round(avg(literacy)) as bottom3 from dataset1
group by state
order by bottom3 asc
limit 3 )as bottom_states


-- states starting with letter a

select state from dataset1
where state ilike 'a%' or state ilike 'b%'
group by state

select state from dataset1
where state ilike 'a%' and state ilike '%m'
group by state

select state from dataset1
where state ilike 'b%' and state ilike '%r'
group by state














