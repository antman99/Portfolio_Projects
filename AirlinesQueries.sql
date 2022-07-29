-- First I Selected all data to make sure data uploaded correctly, this dataset contains 9 columns and over 500k rows with Data about flight delays.

Select *
From Covid_19_project.dbo.Airlines$

-- This Query here was done to show how many delays each airline had in total

Select Airline, count(Airline) as DelaysbyAirline
From Covid_19_project.dbo.Airlines$
Where Delay = 1
Group by Airline
Order by Airline

--I then wanted to select how many flights each airline had in total

Select Airline, count(Airline) as airlineTotalFlights
From Covid_19_project.dbo.Airlines$
Group by Airline
Order by Airline, airlineTotalFlights

--Finally, I wanted to see what day of the week had the most delays

Select DayOfWeek, Count(DayOfWeek) as delaysPerDay
From Covid_19_project.dbo.Airlines$
Where Delay = 1
Group by DayOfWeek
Order by delaysPerDay

--After all the queries were performed, I then proceeded to upload this data to Tableau for visualization