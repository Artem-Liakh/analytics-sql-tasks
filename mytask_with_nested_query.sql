SELECT * FROM salaries LIMIT 10 ;

/* Вивести усіх спеціалістів, у яких заробітна плата 
віща середньої в таблиці */
SELECT *
FROM salaries
WHERE salary_in_usd > 
(
    SELECT     --Вкладений запит
        AVG(salary_in_usd)
    FROM salaries
	WHERE year = '2023-01-01'
);

/* Вивести усіх спеціалістів, які живуть в країнах, 
де середня заробітна плата вища за середню серед усіх країн */

--1. Пошук середньої заробітної плати
SELECT
    AVG(salary_in_usd)
FROM salaries;

--2. Середня з/п по кожній країні
SELECT
    comp_location
	, AVG(salary_in_usd)
FROM salaries
GROUP BY 1;

--3. Порівнюємо, виводимо перелік країн із з/п вище середньої
SELECT
    comp_location
FROM salaries
WHERE year = '2023-01-01'
GROUP BY 1
HAVING AVG(salary_in_usd) >
(    SELECT
         AVG(salary_in_usd)
     FROM salaries
	 WHERE year = '2023-01-01')
;

--4. Cпеціалісти, що проживають у цих країнах
SELECT *
FROM salaries
WHERE emp_location IN (
    SELECT
        comp_location
    FROM salaries
    WHERE year = '2023-01-01'
    GROUP BY 1
    HAVING AVG(salary_in_usd) >
    (    SELECT
             AVG(salary_in_usd)
         FROM salaries
	     WHERE year = '2023-01-01'))
;

/* Знайти мінімальну заробітну плату серед 
максимальних з/п по країнах */

--1. Максимальні з/п по країнах
SELECT
    comp_location
	, MAX(salary_in_usd) AS max_salary
FROM salaries
WHERE year = '2023-01-01'
GROUP BY 1;

--2. Мінімільна з/п серед максимальних 
SELECT
    MIN(t.max_salary) AS min_salary_from_t
FROM 
(
        SELECT
            comp_location
	        , MAX(salary_in_usd) AS max_salary
        FROM salaries
		WHERE  year = '2023-01-01' 
        GROUP BY 1 
) AS t
;

-- Інший варіант (без вкладеного запиту)
SELECT
    comp_location
	, MAX(salary_in_usd) AS max_salary
FROM salaries
WHERE year = '2023-01-01'
GROUP BY 1
ORDER BY 2
LIMIT 1;