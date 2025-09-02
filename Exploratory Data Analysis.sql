# Exploratory Data Analysis (EDA)

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

# Companies with a percenatge_laid_off of 1 means 100 percent of the company was laid off

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

#Observation: looks like it was mostly startup who went out of business this time.

# If we order by funds_raised_millions we can see how much these companies who went out of business raised

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

# Observation: BritishVolt, a London based companys in the transportaion sector went out of business despite raising over 2 billion dollars

# Looking at companies with the most total layoffs

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by sum(total_laid_off) desc;


select min(`date`), max(`date`)
from layoffs_staging2;

# Looking at the industry that got hit the most 

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by sum(total_laid_off) desc;

#Observation: The consumer industry recorded the highest number off layoffs

# Lookin at the country that was most affected by the layoffs

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by sum(total_laid_off) desc;

# Observation: The US was the country most affcted by the layoffs 

# Looking at the year that recorded the highest number off layoffs

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by  1 desc;

# Looking at the stage of companies that had the most layoffs

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

#Observation: companies in the post_IPO stage had the most layoffs

# looking at the total number of layoffs per month

Select substring(`date`,1,7) as `month` ,sum(total_laid_off)
from layoffs_staging2 
where substring(`date`,1,7) is not null
group by `month`
order by 1;

# USing a cte we want to check for the rolling_total of layoffs 

with rolling_total as
(
Select substring(`date`,1,7) as `month` ,sum(total_laid_off) as total_off 
from layoffs_staging2 
where substring(`date`,1,7) is not null
group by `month`
order by 1
)

select `month`, total_off,
sum(total_off) over(order by `month`) as Rolling_total
from rolling_total;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company, year( `date`) ,sum(total_laid_off)
from layoffs_staging2
group by company,year( `date`)
order by sum(total_laid_off) desc;

# looking at the top 5 layoffs of companies per year

with company_year (comoany, years, total_laid_off) as
(
select company, year( `date`) ,sum(total_laid_off)
from layoffs_staging2
group by company,year( `date`)
), company_year_rank as
 
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking  <=5 ;
