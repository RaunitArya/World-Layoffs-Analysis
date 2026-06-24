-- Creating Duplicate Table
create table clean_layoffs as
select *
from layoffs;

select *
from clean_layoffs;

-- Checking data types of columns
select column_name, data_type
from information_schema.columns
where table_name = 'clean_layoffs';

-- Reformating The Table
ALTER TABLE clean_layoffs
    ALTER COLUMN total_laid_off TYPE INTEGER
        USING total_laid_off::INTEGER,

    ALTER COLUMN percentage_laid_off TYPE DECIMAL
        USING percentage_laid_off::DECIMAL,

    ALTER COLUMN date TYPE DATE
        USING TO_DATE(date, 'YYYY/MM/DD'),

    ALTER COLUMN funds_raised_millions TYPE DECIMAL
        USING funds_raised_millions::DECIMAL;

SELECT *
FROM clean_layoffs;

-- Checking Duplicates
WITH duplicate_cte AS
         (select *,
                 row_number() over (partition by company,
                     location,
                     industry,
                     total_laid_off,
                     percentage_laid_off,
                     date,
                     stage,
                     country,
                     funds_raised_millions) as rn
          from clean_layoffs)
select *
from duplicate_cte
where rn > 1;

-- Deleting Duplicates
WITH duplicate_cte AS
         (select CTID,
                 row_number() over (partition by company,
                     location,
                     industry,
                     total_laid_off,
                     percentage_laid_off,
                     date,
                     stage,
                     country,
                     funds_raised_millions) as rn
          from clean_layoffs)
delete
from clean_layoffs
where ctid in (select CTID from duplicate_cte where rn > 1);

-- NOTE: ctid is a special PostgreSQL system column that identifies the physical location of a row within a table.
-- Every row has a ctid value

-- Standardizing Data
select company, trim(company)
from clean_layoffs;

update clean_layoffs
set company = trim(company);

select distinct industry
from clean_layoffs
order by 1;

select *
from clean_layoffs
where industry like 'Crypto%';

update clean_layoffs
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct country, trim(trailing '.' from country)
from clean_layoffs
order by 1;

update clean_layoffs
set country = trim(trailing '.' from country)
where country like 'United States%';

select distinct country
from clean_layoffs
order by 1;


select distinct extract(year from date) as year
from clean_layoffs
order by 1;

-- Handling NULL and Blank Values --
select *
from clean_layoffs
where total_laid_off ISNULL
  and percentage_laid_off ISNULL;

select *
from clean_layoffs
where industry ISNULL
   or industry = '';

select *
from clean_layoffs
where company LIKE 'Bally%';

-- Convert Blanks to NULL
update clean_layoffs
set industry = NULL
where industry = '';

select t1.industry, t2.industry
from clean_layoffs t1
         join clean_layoffs t2
              on t1.company = t2.company
where (t1.industry IS NULL or t1.industry = '')
  and t2.industry IS NOT NULL;


UPDATE clean_layoffs t1
SET industry = t2.industry
FROM clean_layoffs t2
WHERE t1.company = t2.company
  AND t1.industry IS NULL
  AND t2.industry IS NOT NULL;


select *
from clean_layoffs
where total_laid_off ISNULL
  and percentage_laid_off ISNULL;

-- Deleting irrelevant rows
delete
from clean_layoffs
where total_laid_off ISNULL
  and percentage_laid_off ISNULL;


-- Filling funds for company's with NULL values with verified sources --
select company, location, industry, date, funds_raised_millions from clean_layoffs
where funds_raised_millions IS NULL;

UPDATE clean_layoffs
SET funds_raised_millions = 80
WHERE company = 'WeTrade';

UPDATE clean_layoffs
SET funds_raised_millions = 10.71
WHERE company = 'Digital Surge';

UPDATE clean_layoffs
SET funds_raised_millions = 26
WHERE company = 'Crypto.com';

UPDATE clean_layoffs
SET funds_raised_millions = 270.4
WHERE company = 'Akili Labs';

UPDATE clean_layoffs
SET funds_raised_millions = 1013
WHERE company = 'Bolt';

UPDATE clean_layoffs
SET funds_raised_millions = 56.3
WHERE company = 'Daraz';

UPDATE clean_layoffs
SET funds_raised_millions = 17.5
WHERE company = 'DUX Education';

UPDATE clean_layoffs
SET funds_raised_millions = 3
WHERE company = 'Etermax';

UPDATE clean_layoffs
SET funds_raised_millions = 1400
WHERE company = 'Fivetran';

UPDATE clean_layoffs
SET funds_raised_millions = 77.3
WHERE company = 'Gatherly';

UPDATE clean_layoffs
SET funds_raised_millions = 116.5
WHERE company = 'Genesis';

UPDATE clean_layoffs
SET funds_raised_millions = 100
WHERE company = 'GloriFi';

UPDATE clean_layoffs
SET funds_raised_millions = 36.5
WHERE company = 'GoNuts';

UPDATE clean_layoffs
SET funds_raised_millions = 8
WHERE company = 'Harappa';

UPDATE clean_layoffs
SET funds_raised_millions = 10.5
WHERE company = 'Her Campus Media';

UPDATE clean_layoffs
SET funds_raised_millions = 872
WHERE company = 'Heycar';

UPDATE clean_layoffs
SET funds_raised_millions = 31
WHERE company = 'Intapp';

UPDATE clean_layoffs
SET funds_raised_millions = 29.5
WHERE company = 'Intersect';

UPDATE clean_layoffs
SET funds_raised_millions = 1.5
WHERE company = 'Koinly';

UPDATE clean_layoffs
SET funds_raised_millions = 21
WHERE company = 'Lighthouse Labs';

UPDATE clean_layoffs
SET funds_raised_millions = 9.5
WHERE company = 'Loja Integrada';

UPDATE clean_layoffs
SET funds_raised_millions = 15.8
WHERE company = 'MaxMilhas';

UPDATE clean_layoffs
SET funds_raised_millions = 13
WHERE company = 'Me Poupe';

UPDATE clean_layoffs
SET funds_raised_millions = 28
WHERE company = 'Moovel';

UPDATE clean_layoffs
SET funds_raised_millions = 310
WHERE company = 'Newfront Insurance';

UPDATE clean_layoffs
SET funds_raised_millions = 20
WHERE company = 'Nirvana Money';

UPDATE clean_layoffs
SET funds_raised_millions = 5.5
WHERE company = 'Pastel';

UPDATE clean_layoffs
SET funds_raised_millions = 16
WHERE company = 'Payfactors';

UPDATE clean_layoffs
SET funds_raised_millions = 262
WHERE company = 'Productboard';

UPDATE clean_layoffs
SET funds_raised_millions = 13
WHERE company = 'Qin1';

UPDATE clean_layoffs
SET funds_raised_millions = 14.7
WHERE company = 'Relevel';

UPDATE clean_layoffs
SET funds_raised_millions = 5.46
WHERE company = 'Ruggable';

UPDATE clean_layoffs
SET funds_raised_millions = 10.83
WHERE company = 'SSense';

UPDATE clean_layoffs
SET funds_raised_millions = 49
WHERE company = 'Vibrent Health';

UPDATE clean_layoffs
SET funds_raised_millions = 31
WHERE company = 'Wahoo Fitness';

UPDATE clean_layoffs
SET funds_raised_millions = 19
WHERE company = 'Wavely';

UPDATE clean_layoffs
SET funds_raised_millions = 254
WHERE company = 'Willow';

