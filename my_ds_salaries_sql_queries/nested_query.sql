SELECT * FROM salaries LIMIT 10 ;

/* По кожній професії вивести різницю між середньою
та максимальною зарплатою спеціалістів */
--1. Знаходимо макс. з/п

SELECT
	MAX(salary_in_usd) 
FROM salaries;

--2. Таблиця професій і середніх з/п
SELECT
	job_title
	, AVG(salary_in_usd)
FROM salaries
GROUP BY 1;

--3. Результат
SELECT
   job_title
   , ROUND(AVG(salary_in_usd) -
   (SELECT                       /* Вкладений запит(Nested query)
	    MAX(salary_in_usd)                      в блоці SELECT */
    FROM salaries),2) as diff
FROM salaries
GROUP BY 1;

/* ! Вивести дані по співробітнику, який отримує другу (третю, четв...) 
по розміру зарплату в таблиці */

-- Варіант 1
SELECT *
FROM 
    ( SELECT *                    /* Вкладений запит(Nested query)
FROM salaries                                     в блоці FROM */
ORDER BY salary_in_usd DESC
LIMIT 2) as t
ORDER BY salary_in_usd
LIMIT 1;

-- Варіант 2
SELECT *
FROM salaries
ORDER BY salary_in_usd DESC
LIMIT 1 OFFSET 1;
