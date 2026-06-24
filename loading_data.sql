DROP TABLE IF EXISTS layoffs;

CREATE TABLE layoffs
(
    company               TEXT,
    location              TEXT,
    industry              TEXT,
    total_laid_off        TEXT,
    percentage_laid_off   TEXT,
    date                  TEXT,
    stage                 TEXT,
    country               TEXT,
    funds_raised_millions TEXT
);

copy layoffs (
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    date,
    stage,
    country,
    funds_raised_millions)
    from 'PATH-OF-CSV-FILE'
    DELIMITER ',';

select *
from layoffs;
