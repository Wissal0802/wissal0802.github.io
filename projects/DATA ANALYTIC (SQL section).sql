select *
from employee_demographics
where  gender !=  "male" and age <= 40 or first_name like "%a%"
;
-- and this is just a comment 
-- group by 
select gender,avg(age),max(age),min(age), count(age)
from employee_demographics
group by gender 
;

-- order by:
select *
from employee_demographics
order by  5,  birth_date desc
;
-- having vs where
-- we use having with aggregated fct like avg and it has to be after group by and where with the clmns we have 
select occupation, avg(salary)
from employee_salary
where occupation like "%manager%"
group by occupation
having avg(salary)> 60000
;
-- limit and aliasing 
select *
from employee_demographics
order by age
limit 2,5 -- this means start in the 2nd position then select 5 
;
select gender , avg(age) as avg_age -- or we can  remove the "as"  
from employee_demographics
group by gender ;
-- join ;inner join 
select dem.employee_id , gender,occupation
from employee_demographics dem
join employee_salary sal 
 on dem.employee_id = sal.employee_id ; 
 -- outer join (left and right )
 select *
 from employee_demographics dem 
 right join employee_salary sal -- take evrthn in right table and match it with left table
   on dem.employee_id = sal.employee_id ;
-- self join ; joining one table to itself 
select emp1.employee_id ID_SANTA , 
emp1.first_name first_name_santa,
emp1.last_name last_name_santa,
emp2.employee_id ID_emp,
emp2.first_name first_name_emp,
emp2.last_name last_name_emp

from employee_salary  emp1
join employee_salary  emp2
 on    emp1.employee_id +1  = emp2.employee_id
 ;
 -- joining multiple table together
 select *
 from employee_demographics dem
join employee_salary sal
  on dem.employee_id = sal.employee_id
 join parks_departments pd
  on sal.dept_id= pd.department_id
  ;
  
-- unions

select first_name , last_name , "old lady" label
from employee_demographics
where   age >  40 and gender = "female" 
union 
select first_name,last_name , "old male" label
from employee_demographics
where age >40 and gender = "male"
union 
select first_name, last_name, "haighly paid employee" label
from employee_salary
where salary > 70000 
order by first_name , last_name ;
-- just my thinking 
select  dem.first_name , dem.last_name, "old and highly paid employee" label 
from employee_demographics dem
join employee_salary sal
on dem.first_name = sal.first_name
where age > 40  and salary > 70000
;  

-- string function 
select first_name , length(first_name)
from employee_demographics 
order by 2 ;

select first_name , upper(first_name), lower(last_name)
from employee_demographics
;
select trim("   sky   ");
select ltrim("   sky   ");
select rtrim("    sky   ");

select first_name , left(first_name , 4) , -- take the first 4letter from the left(),
right(first_name,3) ,-- first 3letter from the right 
substring(first_name,3,2), -- start with 3 position and take the 2 next letter
substring(birth_date,6,2) birth_month 
from employee_demographics ; 

select first_name , replace(first_name,"a","z")
from employee_demographics ;

select first_name , locate("A",first_name)
From employee_demographics ;

select first_name , last_name,
concat(first_name , " ", last_name) full_name
from employee_demographics;

-- case statements
select first_name , last_name ,age,
case
when age <= 30 then "young"
when age between 31 and 50 THEN "old" 
when age >= 50 then "on death's door" 
end age_bracket
from employee_demographics;


-- pay increase and bonus
-- <50000  = 5%
-- > 50000 = 7%
-- Finance = 10% bonus 
select first_name, last_name, salary,
case
  when salary<50000 then salary * 1.05
  when salary > 50000 THEN salary+(salary*0.07)
 end new_salary,
 case
    when dept_id = 6 then salary*1.10
 end BOnus 
from employee_salary;

-- subqueries
select *
from employee_demographics
where employee_id in 
                     (select employee_id -- we can do just one clmn here 
                     from employee_salary
                     where dept_id = 1 ) ;
                     
select   first_name, last_name, salary,
(select avg(salary) 
from employee_salary 
) avg_sal
from  employee_salary ;

select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender ; --  but we want to do the avg of max age 

select  avg( max_age)
from (select gender, 
	  avg(age) avg_age , 
      max(age)  max_age,
      min(age) min_age, 
      count(age) count_age
      from employee_demographics
      group by gender ) agg_table ;
      
-- Window functions
select gender, avg(salary)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id
group by gender 
;

select dem.first_name, dem.last_name, gender, avg(salary) over(partition by gender)
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id
 ;
 
 select dem.first_name, dem.last_name, gender, salary,
 sum(salary) over(partition by gender order by dem.employee_id ) rolling_total
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id
 ;
 
 
 select dem.first_name, dem.last_name, gender, salary,
row_number() over(partition by gender order by salary desc) row_num ,
rank()  over(partition by gender order by salary desc) rank_num ,
dense_rank()  over(partition by gender order by salary desc) dense_rank_num 
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id
 ;

-- CTEs  common table expression (u use it immediatly )
with CTE_exemple (GENDER, AVG_SAL, MAX_SAL, MIN_SAL, COUNT_SAL)as  -- rather then we alias them 
(select gender , avg(salary) avg_sal, max(salary) max_sal , min(salary) min_sal, count(salary) count_sal
from employee_demographics dem
join employee_salary sal
on dem.employee_id= sal.employee_id
group by gender 
)
select *
from CTE_exemple ;

with CTE_exemple as 
(select employee_id  , gender , birth_date
from employee_demographics
where birth_date > "1985-01-01"
) ,
cte_exemple2 as 
(select employee_id, salary
from employee_salary
where salary > 50000
)
select *
from CTE_exemple
join cte_exemple2
on CTE_exemple.employee_id = cte_exemple2.employee_id;

-- temporary tables
create temporary table temp_table
(first_name varchar(50) ,
last_name varchar(50),
favorite_movie varchar(100) ) ;
insert into temp_table 
values ("wissal","faid","lord of the ring");
select *
from temp_table ;

select*
from employee_salary
;

create temporary table salary_over_50K
select*
from employee_salary
where salary >= 50000 ;
select * 
from salary_over_50K;

-- stored procedures
create procedure large_salaries()
select *
from employee_salary
where salary>=50000 ; 

call  large_salaries() ;
DELIMITER $$ -- it telling us when it ends the stored procedre so we chnged it so it not get confused with ;
create procedure large_salaries3()
begin 
   select *
   from employee_salary
   where salary>=50000 ; 
   select *
   from employee_salary
   where salary>=10000 ; 
END $$
DELIMITER ; -- and here we changed it back to ; 
call  large_salaries3() ;

-- with parameter
delimiter $$
create procedure large_salaries4(employee_id_param int)
begin 
   select salary , first_name
   from employee_salary
   where employee_id = employee_id_param ;
  
END $$
DELIMITER ; 
call  large_salaries4(4) ;

-- triggers and event 
-- triggers :  Runs automatically when data changes (INSERT, UPDATE, DELETE). we change a table it changed in the other too
 select * 
 from employee_demographics
 ;
 select *
 from employee_salary; 
delimiter $$
create trigger employee_insertt
after insert on employee_salary
for each row
begin
  insert into employee_demographics (employee_id,first_name, last_name,)
  values(new.employee_id,NEW.first_name, NEW.last_name);
end$$
delimiter ;
insert into employee_salary (employee_id,first_name,last_name,occupation,salary,dept_id)
values(13,"wissal",'faid','data scientist',1000000, null);


select *
from employee_salary ;

-- EVENTS Runs on a schedule (at a specific time or repeatedly).
delimiter $$
create event delete_retirees
on schedule every 1 month
do 
begin
  delete 
  from employee_demographics
  where age >=60;
end $$
delimiter ;  
       select * 
       from employee_demographics;
       
-- data cleaning full project

select *
from layoffs ;       
-- 1 remove duplicates
-- 2 standarize the data
-- 3 null values or blank values
-- 4 remove any columns
 create table layoffs_staging -- we create a staging cuz we'll modify it 
 like layoffs ;
 insert layoffs_staging
 select * 
 from layoffs;
 select *
 from layoffs_staging;
 
 -- removing duplicates
 select * ,
 row_number () over (
 partition by company, industry,total_laid_off,percentage_laid_off,"date") as row_numb
 from layoffs_staging ;
 
 with duplicate_cte as
 ( select * ,
 row_number () over (
 partition by company, location,industry,total_laid_off,percentage_laid_off,"date",stage,country,
 funds_raised_millions) as row_numb
 from layoffs_staging ) 
 select*
 from duplicate_cte 
 where  row_numb >1;


 CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_numb` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

 
 select *
 from layoffs_staging3
 where row_numb > 1;
 
 
 insert into layoffs_staging3
 select * ,
 row_number () over (
 partition by company, location,industry,total_laid_off,percentage_laid_off,"date",stage,country,
 funds_raised_millions) as row_numb
 from layoffs_staging ;
 
 SET SQL_SAFE_UPDATES = 0; -- i did so that i can delete if i want turn it on replace with 1 
 delete 
 from layoffs_staging3 
 where row_numb >1 ;
 select *
 from layoffs_staging3 ; -- now we removed duplicates 
 
 -- standardizing Data ; finding issues in data and fixing it 
 update layoffs_staging3
 set company = trim(company); -- to remove space from beginning
  
  select distinct industry
  from layoffs_staging3
  order by 1 ; -- industry 
  
  select*
  from layoffs_staging3 
  where industry like "crypto%"; -- most of them are crypto
  
  update layoffs_staging3 
  set industry = "crypto"  
  where industry like "crypto%"; -- done 
  select distinct industry 
  from layoffs_staging3 
  order by 1; -- done
 select distinct location
  from layoffs_staging3 
  order by 1;  
  select distinct country
  from layoffs_staging3 
  order by 1;-- looks like we have us ans US.
  
  select country 
  from layoffs_staging3 
where country like 'united states%' ; 

update layoffs_staging3 
set country = trim(trailing"." from country) -- a little trick that he used 
where country like "united state%"; 
update layoffs_staging3  
set country = 'United States' 
where country like "united state%" ; -- done
 -- the date is written like text we'll turn it into date 
 select `date`,
 str_to_date (`date`, '%m/%d/%Y')
 from layoffs_staging3 ;

update layoffs_staging3
set `date` = str_to_date (`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date ;

-- removing nulls and blanks 

select *
from layoffs_staging3
where total_laid_off is null
and percentage_laid_off is null ;

update layoffs_staging2
set industry = null 
where industry= '' ;


select *
from layoffs_staging2
where company ="airbnb"; 


select t1.industry , t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
  on t1.company= t2.company
 where t1.industry is null 
 and t2.industry is not null ;
 
 update layoffs_staging2 t1
 join layoffs_staging2 t2 
 on t1.company= t2.company
 set t1.industry = t2.industry
 where t1.industry is null 
 and t2.industry is not null ;
 -- removing colmn we don't need
 select*
 from layoffs_staging2
 where 
 total_laid_off is null
 and percentage_laid_off is null ;
 
 delete 
 from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null ;
 select*
 from layoffs_staging2;
  
alter table layoffs_staging2
drop column row_numb; 
-- i want to delete the duplicates ligne in staging3 and staging2 i added clmn id and did that code


 ALTER TABLE layoffs_staging3 ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;
 
 WITH duplicates AS (
    SELECT id,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry ORDER BY id) AS rn
    FROM layoffs_staging3
)
DELETE FROM layoffs_staging3
WHERE id IN (
    SELECT id FROM duplicates WHERE rn > 1
);
select *
from layoffs_staging2
order by company ;
alter table layoffs_staging2 add column id int auto_increment primary key;

with dublicat as 
 (select id,
row_number()over( partition by company,location,industry order by id)as rn
from layoffs_staging2)
delete from layoffs_staging2
where id in (
select id from dublicat where rn>1
);
alter table layoffs_staging2
drop column id;
select *
from layoffs_staging2;

-- exploratory data analysis 
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;
select *
from layoffs_staging2
where percentage_laid_off = 1 
order by funds_raised_millions desc ;

select company , sum(total_laid_off)
from layoffs_staging2
group by company 
order by 2 desc;

select min(`date`),max(`date`)
from layoffs_staging2;

select industry , sum(total_laid_off)
from layoffs_staging2
group by industry 
order by 2 desc;
select country , sum(total_laid_off)
from layoffs_staging2
group by country 
order by 2 desc;
select year (`date`) , sum(total_laid_off)
from layoffs_staging2
group by year( `date` )
order by 1 desc;
select stage , sum(total_laid_off)
from layoffs_staging2
group by stage
order by 1 desc;

select substring(`date`,1,7) as month , sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by month 
order by 1 asc;

with rolling_total as 
 
(select substring(`date`,1,7) as month , sum(total_laid_off)as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by month 
order by 1 asc
)
select month , total_off , sum(total_off) over(order by month) rolling_total
from rolling_total;


with company_year (company, years , total_laid_off)as 
(select company , year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company ,  year(`date`)
),
company_year_rank as(
select *, 
dense_rank() over(partition by years order by total_laid_off desc) as ranking 
-- to see for exemple l cumul of total laid off in 2022 lone and in 2021 alone .. 
from company_year
where years is not null)
select*
from company_year_rank
where ranking <=5;

-- Total layoffs by year
 SELECT 
    YEAR(`date`) AS year,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE `date` IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY year;
 

 -- Top 10 companies by total layoffs
SELECT 
    company,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE company IS NOT NULL
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;

-- Top industries by layoffs
SELECT 
    industry,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY total_laid_off DESC
LIMIT 10;

-- Top countries by layoffs
SELECT 
    country,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_laid_off DESC
LIMIT 10;




-- Top 5 companies for each year
WITH company_year AS (
    SELECT 
        company,
        YEAR(`date`) AS year,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY company, YEAR(`date`)
),
company_year_rank AS (
    SELECT *,
        DENSE_RANK() OVER (
            PARTITION BY year 
            ORDER BY total_laid_off DESC
        ) AS ranking
    FROM company_year
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5
ORDER BY year, ranking;


 
 
 

 



  
