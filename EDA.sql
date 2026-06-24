select * from clean_layoffs;

select max(total_laid_off), max(percentage_laid_off)
from clean_layoffs;

-- Identifying Company shutdowns --
select
* from clean_layoffs
where percentage_laid_off = 1
order by date desc;

-- Checking total laid offs --
select company, sum(total_laid_off) as total_laid_offs
from clean_layoffs
where total_laid_off IS NOT NULL
group by company
order by 2 desc;
-- Amazon, Google & Meta are the top companies with most layoffs

-- Checking date range in dataset --
select min(date), max(date) from clean_layoffs;
-- Data ranges from March 2020 to March 2023

-- Checking industry with most layoffs --
select industry, sum(total_laid_off) as total_laid_offs
from clean_layoffs
where total_laid_off IS NOT NULL
group by industry
order by 2 desc;
-- Consumer and Retail are the most affected industries


-- Countries with most laid offs --
select country, sum(total_laid_off) as total_laid_offs
from clean_layoffs
where total_laid_off IS NOT NULL
group by country
order by 2 desc
limit 15;
-- US and India are top 2 countries with most layoffs

select country, sum(total_laid_off) as total_laid_offs, extract(year from date) as year
from clean_layoffs
where total_laid_off IS NOT NULL
group by country, year
order by 2 desc;

-- Total laid offs around the world from 2020-2023 --
select extract(year from date) as year, sum(total_laid_off) as total_laid_offs
from clean_layoffs
where date IS NOT NULL
group by 1
order by 2 desc;
-- 2022 had the most laid offs of around 160661, followed by 2023, 2020 & 2021

-- Checking total laid offs in a company stagewise
select stage, sum(total_laid_off) as total_laid_offs
from clean_layoffs
where stage IS NOT NULL
group by 1
order by 2 desc;
-- Maximum laid offs is in Post-IPO Companies like Amazon, Google

-- Layoff Severity across Company Size --
SELECT stage, ROUND(AVG(percentage_laid_off)*100,2) as avg_pct_laid_off
FROM clean_layoffs
WHERE percentage_laid_off IS NOT NULL
GROUP BY stage
ORDER BY 2 DESC;
-- a large company with a layoff proportion of 0.05 could still show more people being laid off,
-- then a smaller company with a layoff proportion of 0.7,
-- even though this gives valuable insight that the past 3 years have hit small companies very hard.

-- Also checking how many companies are in each stage
SELECT
    stage,
    COUNT(*) AS layoffs_events,
    ROUND(AVG(percentage_laid_off)*100,2) AS avg_pct_laid_off
FROM clean_layoffs
WHERE percentage_laid_off IS NOT NULL
GROUP BY stage
ORDER BY avg_pct_laid_off DESC;



-- Layoff Severity across Industry --
SELECT industry, ROUND(AVG(percentage_laid_off)*100,2) AS avg_pct_laid_off
FROM clean_layoffs
WHERE percentage_laid_off IS NOT NULL
GROUP BY industry
ORDER BY 2 DESC;
-- Top 3 affected industries - Aerospace, Education, Travel

-- Distribution of Layoff Severity --
SELECT
    CASE
        WHEN percentage_laid_off < 0.10 THEN '0-10%'
        WHEN percentage_laid_off < 0.25 THEN '10-25%'
        WHEN percentage_laid_off < 0.50 THEN '25-50%'
        WHEN percentage_laid_off < 1 THEN '50-99%'
        ELSE '100%'
        END AS layoff_bucket,
    COUNT(*) AS companies
FROM clean_layoffs
WHERE percentage_laid_off IS NOT NULL
GROUP BY layoff_bucket
ORDER BY companies DESC;
-- It answers:
--     are most layoffs small workforce reductions?
--     how common are mass layoffs?

-- Most Severe Layoffs --
SELECT company,
       date,
       percentage_laid_off,
       total_laid_off
FROM clean_layoffs
WHERE percentage_laid_off IS NOT NULL
AND total_laid_off IS NOT NULL
ORDER BY percentage_laid_off DESC,
         total_laid_off DESC;

-- Funding vs Layoff Percentage --
SELECT
    CORR(funds_raised_millions, percentage_laid_off)
FROM clean_layoffs
WHERE funds_raised_millions IS NOT NULL
  AND percentage_laid_off IS NOT NULL;
-- -0.06791280976768858

-- Country level Lay-off Severity --
SELECT country,
       ROUND(avg(percentage_laid_off)*100,2) AS avg_pct
FROM clean_layoffs
WHERE percentage_laid_off IS NOT NULL
GROUP BY country
HAVING COUNT(*) > 5
ORDER BY avg_pct DESC;


-- Rolling sum of total laid offs month-wise --

select to_char(date, 'YYYY-MM') as Year_Month, sum(total_laid_off)
from clean_layoffs
where date IS NOT NULL
group by 1
order by 1;

with rolling_sum as (select to_char(date, 'YYYY-MM') as Year_Month, sum(total_laid_off) as total_offs
                     from clean_layoffs
                     where date IS NOT NULL
                     group by 1
                     order by 1)
select Year_Month, total_offs,
       sum(total_offs) OVER (order by Year_Month) as rolling_total
from rolling_sum;


-- Company layoffs per year
select company, extract(year from date) as year, sum(total_laid_off) as total_laid_offs
from clean_layoffs
where total_laid_off IS NOT NULL
group by company, year
order by 3 desc;

-- Ranking highest laid off per year
with company_year as (select company, extract(year from date) as year, sum(total_laid_off) as total_laid_offs
                      from clean_layoffs
                      where total_laid_off IS NOT NULL
                      group by company, year),
Company_year_rank as (select *, dense_rank() over (PARTITION BY year ORDER BY total_laid_offs desc) as ranking
                      from company_year)
select * from Company_year_rank
where ranking <= 5;

-- Pandemic vs Post-Pandemic Analysis --
select
    CASE
        WHEN date < '2022-01-01' THEN 'COVID Era'
        ELSE 'Post COVID'
        END AS period,
    round(avg(percentage_laid_off)*100, 2) as avg_pct_laidoff
from clean_layoffs
where percentage_laid_off IS NOT NULL
group by period;
-- layoffs during COVID were more severe than those during the 2022–2023
