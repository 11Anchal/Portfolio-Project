select * from project.dataset1;
select * from project.dataset2;
-- no. of rows into our dataset1
 select count(*) from dataset1;
  select count(*) from dataset2;
  
  
  -- dataset for jharkhand and bihar
  select * from dataset1 where state in( 'jharkhand','bihar');
  -- population in india
  select sum(population) as population from dataset2;
-- average growth of india
select avg(growth) as avg_growth from project.dataset1;
select state,avg(literacy) as avg_literacy from project.dataset1 group by state order by avg(literacy) desc;
select state,avg(growth) as avg_growth from project.dataset1 group by state;
select state,round(avg(sex_ratio),0) as sex_ratio from project.dataset1 group by state
order by avg(Sex_Ratio) desc;
-- top 3 state highesr growth rate
select state,round(avg(growth)) as avg_growth from project.dataset1 group by state order by avg(growth) desc limit 3;

-- bottom 3 state lowest growth rate
select state,round(avg(growth)) as avg_growth from project.dataset1 group by state order by avg(growth) limit 3;

-- bottom 3 state lowest sex ratio
select state,round(avg(sex_ratio),0) as sex_ratio from project.dataset1 group by state
order by avg(Sex_Ratio) asc limit 3;
-- top 3 and bottom 3 state in litracy
select * from (select state,round(avg(literacy)) from project.dataset1 group by state order by avg(Literacy) desc limit 3) as a
union all
select * from(
select state,round(avg(literacy)) from project.dataset1 group by state order by avg(Literacy) asc limit 3) as b;
