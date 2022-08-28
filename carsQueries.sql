--Skills demonstrated include Update, Cast, Subqueries, CTE, Temp table, Views, Having, Distinct, Use of aggregate functions

--First check to see if data imported correctly

Select *
From Projects.dbo.vehicles$

Select Distinct year
From Projects.dbo.vehicles$
Where year is not null
Order by year asc
 


--Update the data in the table so proper queries can be ran later, removing nulls and changing the date to a yearly format

Select Cast(Left(posting_date, 10) as date)
From Projects.dbo.vehicles$

Update Projects.dbo.vehicles$
Set posting_date =  Cast(Left(posting_date, 10) as date);

Update Projects.dbo.vehicles$
Set state = NULL
Where state = ''

Update Projects.dbo.vehicles$
Set model = NULL
Where model = ''


--Use CTE to get the vehicle with the most listings per year going back 20 years
With CTE_models_Years as
(Select model, year, count(model) as amount
From Projects.dbo.vehicles$
Where year is not null and model is not null
Group by model, year 
-- Replace 2002 with next 19 years to get top model listings by year
Having year = 2022)
Select top 1 year, model, amount
From CTE_models_Years
WHere amount > 100
Group by year, model, amount
Order by amount desc


--Create temp table to store data

Create table #Temp_model_year
(
Years varchar(255),
Models varchar(255),
Amount int
)


Insert into  #Temp_model_year Values
('2003', 'f-150','169'),
('2004', 'f-150','156'),
('2005', 'f-150','137'),
('2006', 'f-150','223'),
('2007', 'Camry','287'),
('2008', 'Accord','239'),
('2009', 'Camry','218'),
('2010', 'f-150','485'),
('2011', 'f-150','381'),
('2012', 'f-150','417'),
('2013', 'f-150','907'),
('2014', 'f-150','811'),
('2015', 'f-150','647'),
('2016', 'Scion iM Hatchback 4D','673'),
('2017', 'f-150','713'),
('2018', 'f-150','915'),
('2019', '1500 classic regular cab','402'),
('2020', 'ranger supercab xl pickup','370'),
('2021', 'silverado 1500','101')

--Check if values were stored correctly while also using temp table for easy access to data

Select *
From #Temp_model_year
Order by Years asc

--Create a view to calculate what percent of listed transmittions are automatic or manual

Create View Trasmission_type as
Select transmission, Count(transmission) as totalpertype
From Projects.dbo.vehicles$
Where transmission is not null And transmission not like '%other%'
group by transmission


--Perform calculation 

Select transmission, totalpertype * 100/(Select SUM(totalpertype) from Trasmission_type) as percentageOfTotal
From Trasmission_type



--Finally Select the most popular models by what condition they were most often listed as

Select Count(model) as model_occurences, model, condition
From Projects.dbo.vehicles$
where model is not null and condition is not null and model in ('f-150', 'Scion iM Hatchback 4D', 'Accord', 'Camry','1500 classic regular cab', 'ranger supercab xl pickup','silverado 1500')
Group by model, condition
Order by model_occurences desc

--Fin