/*
Here's the first-touch query, in case you need it
*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp;
	
	
-- Query for distinct campaigns
SELECT COUNT(DISTINCT(utm_campaign)) As 'Total Number of Campaigns'
FROM Page_visits;

SELECT DISTINCT(utm_campaign) AS 'Current Campaigns'
FROM Page_visits
ORDER BY 1;


-- Query for distinct sources
SELECT COUNT(DISTINCT(utm_source)) As 'Total Number of Sources'
FROM Page_visits;

SELECT DISTINCT(utm_source) AS 'Current Sources'
FROM Page_visits
ORDER BY 1;

-- Query for distinct pages
SELECT COUNT(DISTINCT(page_name)) As 'Total Number of Pages'
FROM Page_visits;

SELECT DISTINCT page_name AS 'Current Pages'
FROM Page_visits
ORDER BY 1;

--Query for total first-touch traffic grouped by campaign
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign As 'Campaign',
   COUNT(ft.user_id) As 'Total First Touches'
FROM page_visits pv
LEFT JOIN first_touch ft
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;

--Query for total last-touch traffic grouped by campaign
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign As 'Campaign',
   COUNT(lt.user_id) As 'Total Last Touches'
FROM page_visits pv
LEFT JOIN last_touch lt
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;


-- Query for total buying visitors
SELECT page_name,
COUNT(DISTINCT(user_id)) AS 'Buying Visitors'
FROM page_visits
WHERE page_name = '4 - purchase';


--Query for total last-touch traffic resulting in a purchase
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
 		WHERE page_name = '4 - purchase'
    GROUP BY user_id)
SELECT pv.utm_campaign As 'Campaign',
   COUNT(lt.user_id) As 'Total Last Touches'
FROM page_visits pv
LEFT JOIN last_touch lt
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;

--Final query which combines first touch with last touch summary and includes a column for total of first and last touch traffic
WITH 
first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id
),
last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id
),
ft_table As (
  SELECT pv.utm_campaign As 'Campaign',
   COUNT(ft.user_id) As 'Total_First_Touches'
FROM page_visits pv
LEFT JOIN first_touch ft
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC
  ),
lt_table As (  
  SELECT pv.utm_campaign As 'Campaign',
   COUNT(lt.user_id) As 'Total_Last_Touches'
FROM page_visits pv
LEFT JOIN last_touch lt
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC
  )
  SELECT ft.Campaign As 'Campaign',
  	ft.Total_First_Touches As 'Total First Touches',
  	lt.Total_Last_Touches As 'Total Last Touches',
    ft.Total_First_Touches + lt.Total_Last_Touches As 'Combined'
  FROM ft_table ft
  JOIN lt_table lt
  	ON ft.Campaign = lt.Campaign
  ORDER BY 4 DESC;




	