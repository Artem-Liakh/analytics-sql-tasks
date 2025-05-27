SELECT * FROM salaries LIMIT 10 ;

/* #1 Вивести з/п спеціаліста ML Engineer в 2023 році,
додати сортування за зростанням з/п: */
SELECT 
    year
	, job_title
	, salary_in_usd
FROM salaries
WHERE year = '2023-01-01' AND job_title = 'ML Engineer'
ORDER BY 3 ASC;

/* #2 Назвати країну, в якій зафіксована найменша з/п спеціаліста
в сфері Data Scientist в 2023р */
SELECT
    year
	, job_title
	, exp_level
	, comp_location AS country
	, salary_in_usd
FROM salaries
WHERE year = '2023-01-01'
        AND job_title = 'Data Scientist'
ORDER BY 5
LIMIT 1;

/* #3 Вивести топ-5 з/п серед усіх спеціалістів, які працюють 
повність віддалено */
SELECT
    salary_in_usd
	, remote_ratio
FROM salaries
WHERE remote_ratio = 100
ORDER BY 1 DESC
LIMIT 5;

/* #4 Вивести унікальні значення для колонки */
SELECT DISTINCT comp_location AS company_location
FROM salaries;

/* #5 Вивести кількість унікальних значень колонки */
SELECT
COUNT(DISTINCT comp_location) AS number_company_location
FROM salaries;

/* #6 Вивести середню, максимальну та мінімальну з/п для 2023р */
SELECT
    ROUND(AVG(salary_in_usd)) AS avg_salary
	, ROUND(MAX(salary_in_usd)) AS max_salary
	, ROUND(MIN(salary_in_usd)) AS min_salary
FROM salaries
WHERE year = '2023-01-01'
;

/* #7Вивести 5 найвищих з/п у 2023р для ML Engineer. ЗП перевести у грн */
SELECT
    year
	, salary_in_usd
	, salary_in_usd * 41.5 AS salary_in_UAH
	, job_title
FROM salaries
WHERE year = '2023-01-01'
        AND job_title = 'ML Engineer'
ORDER BY 2 DESC
LIMIT 5;

/* #8 Вивести унікальне значення колонки remote_ratio, формат даних має  бути 
дробовим з двома знаками після коми */
SELECT
    DISTINCT ROUND((remote_ratio/100.0),2) AS remote_frac
FROM salaries;

/* #9 Вивести дані таблиці, додавши колонку exp_level_full з повною назвою
досвіду працівників відповідно до колонки exp_level */
SELECT *
    , CASE
	  WHEN exp_level = 'EX' THEN 'Executive_level'
	  WHEN exp_level = 'MI' THEN 'Middle_level'
	  WHEN exp_level = 'EN' THEN 'Entry_level'
	  ELSE 'Senior_level' END 
	                            AS exp_level_full
FROM salaries
LIMIT 10;

/* #10 Дослідити колонки на наявність відсутніх значень */
SELECT COUNT (*) - COUNT(salary_in_usd)
FROM salaries;


