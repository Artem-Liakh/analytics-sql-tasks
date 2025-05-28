SELECT * FROM salaries LIMIT 10 ;

/* #11 Для кожної професії та відповідного рівня досвіду навести:
- кількість в таблиці 
- середню заробітну плату */
SELECT 
   job_title
   , exp_level
   , COUNT(*) AS job_number
   , ROUND(AVG(salary_in_usd),2) AS avg_salary_in_usd
FROM salaries
WHERE year = '2023-01-01'
GROUP BY job_title, exp_level
ORDER BY 1,2;

/* #12 Для професій, які зустрічаються лише 1 раз,
навести заробітну плату*/
SELECT 
   job_title
   --, COUNT(*) AS job_number
   , ROUND(AVG(salary_in_usd),2) AS avg_salary_in_usd
FROM salaries
WHERE year = '2023-01-01'
GROUP BY job_title
HAVING COUNT(*) = 1
ORDER BY 2 DESC;

