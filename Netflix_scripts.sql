-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows

SELECT type, COUNT(*) FROM netflix
	GROUP BY type;

SELECT * FROM netflix;

-- 2. Find the most common rating for movies and TV shows

SELECT type, rating
FROM    
(
SELECT 
    type, rating, COUNT(*),
    RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS RANKING
    FROM netflix
GROUP BY 1, 2
) as t1
    WHERE ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT type, title, release_year FROM netflix
WHERE type = 'Movie' AND release_year = 2020
GROUP BY 1, 2, 3;

-- 4. Find the top 5 countries with the most content on Netflix

SELECT DISTINCT UNNEST(STRING_TO_ARRAY(country, ',')),
    COUNT(show_id) AS Total_content
    FROM netflix
    GROUP BY 1 
    ORDER BY 2 DESC
    LIMIT 5;

-- 5. Identify the longest movie

SELECT * FROM netflix
	WHERE type = 'Movie'
	AND 
	duration = (SELECT MAX(duration) FROM netflix);

-- 6. Find content added in the last 5 years
SELECT 
    *, 
    TO_DATE(date_added, 'Month DD, YYYY') AS formatted_date
FROM 
    netflix
WHERE 
    TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT show_id, Title, director, COUNT(show_id) FROM netflix
WHERE director = 'Rajiv Chilaka'
GROUP BY show_id, Title, director;

-- 8. List all TV shows with more than 5 seasons

SELECT *,
		SPLIT_PART(duration, ' ', 1) AS no_of_sessions
FROM netflix
	WHERE type = 'TV Show' AND 
	SPLIT_PART(duration, ' ', 1)::numeric > 5;

-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')),
	COUNT(show_id)
	FROM netflix
	GROUP BY 1
	ORDER BY 2 DESC;

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) AS yearly_content,
ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India') * 100 
	, 2)as avg_content_per_year
	From netflix
	WHERE country = 'India'
GROUP BY 1;

-- 11. List all movies that are documentaries

SELECT * FROM netflix
	WHERE 
	listed_in ILIKE '%documentaries%';

-- 12. Find all content without a director

SELECT * FROM netflix
	WHERE
	director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
	WHERE casts
	ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE)- 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')),
	COUNT(*) AS total_content
	FROM netflix
	WHERE country ILIKE '%india%'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10;

-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
SELECT * FROM netflix
	WHERE description ILIKE '%kill%'
	OR
	description ILIKE '%violence%';

-- Using case statements

SELECT *
	CASE
	WHEN WHERE description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad Film'
FROM netflix;






