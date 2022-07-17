use db2019project_googleplaystore;

#1 What category of applications is the most popular among users?
select Category, 
count(Category) as number_of_apps,
 round(avg(Installs),0) as avg_installs
from apps
group by Category
order by avg_installs desc;

#2 What categories of “topical” apps are rated above average?
SELECT Category,
    ROUND(avg(a.Rating), 2) AS avg_rating,
    (SELECT round(avg(Rating), 2) 
     FROM apps
     where t.Last_Updated > '2018-01-01') AS overall_rating
    from apps as a
inner JOIN tech_inf as t
ON a.ID=t.ID
WHERE t.Last_Updated > '2018-01-01'
GROUP BY Category
HAVING avg_rating IS NOT NULL
ORDER BY avg_rating DESC;

#3 What is the ratio of successful to bad relationships in each category? 
select Category, 
round (avg (case when Sentiment = 'Positive' or Sentiment = 'Neutral' and Rating > 4.7 
				 then 1 
				 else 0 end), 2) as pers_good_apps
from apps 
right join reviews
on `Name` = AppName
where Installs >= 500000
group by Category
order by pers_good_apps desc;

#4 Does the date of the last update   (how long has the application been updated) of applications influences on the number of downloads?
select distinct `Name`, 
				Category, 
                Last_Updated, 
                Installs 
from apps as a
inner join tech_inf as t
ON a.ID=t.ID
group by `Name`
order by Installs desc;

#5 Does the size of the application affect the number of downloads?
select distinct `Name`,
				Category, 
                Size, 
                Installs
from apps as a
inner join tech_inf as t
ON a.ID=t.ID
where size NOT IN ('Varies with device')
group by `Name`
order by Installs desc;

#6 What are the 5 “best” apps?
select distinct (`Name`), 
				Category, 
                Genres, 
                Rating, 
                Installs, 
                Sentiment
from apps 
inner join reviews
on `Name` = AppName
where Rating > 4.7
and Installs >= 500000
and Sentiment = 'Positive'
Order by Rating desc
limit 5;

#7 What are the 5 “worst” apps?
select distinct (`Name`),
				Category, 
                Genres, 
                Rating, 
                Installs, 
                Sentiment
from apps 
inner join reviews
on `Name` = AppName
where Rating < 3.7
and Installs >= 500000
and Sentiment = 'Negative'
Order by Rating asc
Limit 5;

#8 What is the difference in the number of reviews between the “best” and the “worst” application?
select
(select Reviews
from apps 
inner join reviews
on `Name` = AppName
where Rating > 4.7
and Installs >= 500000
and Sentiment = 'Positive'
Order by Rating desc
Limit 1) -
(select Reviews
from apps 
inner join reviews
on `Name` = AppName
where Rating < 3.7
and Installs >= 500000
and Sentiment = 'Negative'
Order by Rating desc
limit 1)  as diff
from apps;

#9 What are the most popular paid apps?
select distinct(`Name`),
				Category,
                Rating,
                Genres,
                Installs
from apps 
where Installs >= 500000
and `Type` = 'Paid'
and Rating is not null
order by Installs desc;

#10 What applications in each category of content rating have the most Installs?
select  distinct(`Name`),
		Category, 
        Content_Rating, 
        max(Installs) as max_Installs
from apps
group by Content_Rating
order by max_Installs desc;

#11 Which apps that have been installed at least 500.000 times have number of reviews above average?
select distinct(`Name`),
	   Category,
       Reviews
from apps
where Reviews > (select avg(Reviews) from apps)
and Installs >= 500000
group by `Name`
order by Reviews desc;

#12 What genres of games are most popular in terms of the average number of installations and rating?
select Category,
	   Genres, 
       count(Genres) as number_of_apps, 
       round(avg(Rating), 2) as avg_rating, 
       round(avg(Installs), 2) as avg_installs
from apps
where Category = 'GAME'
group by Genres
order by avg_installs desc;

#Part 2
----------------------------------

#13 Are there Homescapes and Gardenscapes?
select *
from apps
where `Name` like '%scapes'
group by `Name`;

#14 How do users rate Homescapes and Gardenscapes in terms of rating?
select distinct(`Name`), Category, Rating, 
(select round(avg(Rating), 2) from apps) as avg_rating_all_apps,
(select round(avg(Rating), 2) from apps where Category = 'GAME') as avg_rating_games,
(select round(avg(Rating), 2) from apps where Category = 'GAME' and Genres = 'Casual') as avg_rating_casual_games
from apps
where `Name` like '%scapes'
and Genres = 'Casual';

#15 What are the difference between “Positive” and “Negative” reviews for Homescapes?
select AppName as `Name`, 
(select count(Sentiment) 
from reviews
where Sentiment = 'Negative' and AppName = 'Homescapes') as Negative,
(select count(Sentiment) 
from reviews
where Sentiment = 'Positive' and AppName = 'Homescapes') as Positive,
(select count(Sentiment) 
from reviews
where Sentiment = 'Positive' and AppName = 'Homescapes') - 
(select count(Sentiment) 
from reviews
where Sentiment = 'Negative' and AppName = 'Homescapes') as Difference
from reviews
where AppName = 'Homescapes'
group by AppName;

#16 What are the difference between “Positive” and “Negative” reviews for Gardenscapes?
select AppName as `Name`, 
(select count(Sentiment) 
from reviews
where Sentiment = 'Negative' and AppName = 'Gardenscapes') as Negative,
(select count(Sentiment) 
from reviews
where Sentiment = 'Positive' and AppName = 'Gardenscapes') as Positive,
(select count(Sentiment) 
from reviews
where Sentiment = 'Positive' and AppName = 'Gardenscapes')
 - (select count(Sentiment) 
from reviews
where Sentiment = 'Negative' and AppName = 'Gardenscapes') as Difference
from reviews
where AppName = 'Gardenscapes'
group by AppName;