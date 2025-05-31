/* Порядок роботи з новою таблицею*/

-- Загальне уявлення про дані
SELECT *
FROM salaries
LIMIT 10;

-- Кількість  рядків в таблиці
SELECT COUNT (*)
FROM salaries;

-- Кількість пропущених значень в колонці
SELECT
    COUNT(*)
	, COUNT(*) - COUNT(salary_in_usd) as missing_values
FROM salaries;

-- Знайомство з показниками категорійних, текстових... тощо полів. 
--Оцінка обсягу інформації
SELECT
    job_title
	, COUNT(*)
FROM salaries
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;           -- можливо, додати LIMIT

-- Знайти min, max, avg, stddev....
SELECT
    job_title
	, exp_level
	, MIN(salary_in_usd)
	, MAX(salary_in_usd)
	, ROUND(AVG(salary_in_usd),2) as avg
	, stddev(salary_in_usd)
FROM salaries
GROUP BY 1,2;
 
-- Дистрибʼюція (розподіл) числових даних
SELECT
    TRUNC(salary_in_usd, -1)      -- TRUNC - функція усічення 127 = 120
	, COUNT(*)
FROM salaries
GROUP BY 1;

-- Можливість створювати Groups and/or Bins
SELECT
    CASE
	    WHEN salary_in_usd >= 200000 THEN 'A' 
		WHEN salary_in_usd <= 200000 and salary_in_usd >= 100000 THEN 'B'
		WHEN salary_in_usd < 100000 and salary_in_usd >= 50000 THEN 'C'
		WHEN salary_in_usd < 50000 and salary_in_usd >= 10000 THEN 'D'
		WHEN salary_in_usd < 10000 and salary_in_usd >= 5000 THEN 'E'
		ELSE 'F' END as salary_category
		, COUNT (*)
FROM salaries
GROUP BY 1;

/* Перевірка кореляції (чи впливає зміна значень в одному стовпчику
на зміну значення в іншому стовпчику) */
SELECT 
    corr(remote_ratio, salary_in_usd)
FROM salaries;
