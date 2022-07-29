-- I always start by checking to see if data imported corrctly, making sure to take note of how the data is organized
-- This data set contains information on data science jobs posted in the past 2 years, specifially salary, job titles, experience, employment type, and company size

Select *
From project.dbo.ds_salaries$;

-- The first query I run below shows how many jobs there are for each job title, with the average salary for each position also shown

Select job_title, Count(job_title) as jobsPerTitle, AVG(salary_in_usd) as payInUSD
From project.dbo.ds_salaries$
Group by job_title
Order by JobsPerTitle;

-- Next I want to find out how the job market for data science has changed over the last 3 years

Select work_year, count(job_title) as jobsPerYear
From project.dbo.ds_salaries$
Group by work_year
Order by work_year;

--This next query is to show how much experience is requiered (Entry level, Mid-level, Senior, Phd)

Select experience_level, count(experience_level) as groups
From project.dbo.ds_salaries$
Group by experience_level
Order by groups

-- This is a query to show how common remote, hybrid, and on-site positions are

Select remote_ratio, count(remote_ratio) jobsPerCategory
From project.dbo.ds_salaries$
Group by remote_ratio
Order by jobsPer

-- Finally, I wanted to find out how the jobs were distributed between small, medium, and large companies

Select company_size, count(company_size) as jobspersize
From project.dbo.ds_salaries$
Group by company_size
order by company_size

--The very last thing I need to do was export all this data to tableau to create into a visualization