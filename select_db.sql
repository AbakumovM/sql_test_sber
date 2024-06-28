-- ЗАДАНИЕ 1
-- A. Написать запрос который выведет следующую таблицу (Т):

SELECT 
	u.name, 
	c.d_number, 
	to_char(o.dt, 'dd.mm.yyyy') as dt, 
	o.summa
FROM users u 
	JOIN contracts c ON u.client_id = c.client_id 
	JOIN operations o ON c.d_id = o.d_id;
	


-- Б. Вывести клиентов с максимальной датой сделки (Если с такой датой клиентов несколько, вывести всех):

SELECT 
	u.name, 
	c.d_number, 
	to_char(o.dt, 'dd.mm.yyyy') as dt, 
	o.summa
FROM users u 
	JOIN contracts c ON u.client_id = c.client_id 
	JOIN operations o ON c.d_id = o.d_id
WHERE o.dt = (SELECT MAX(dt) FROM operations);



-- В. Вывести номера договоров без операций:

SELECT 
	name, 
	c.d_number 
FROM users u 
	JOIN contracts c ON u.client_id = c.client_id 
WHERE c.d_id NOT IN (SELECT d_id 
				     FROM operations
					 GROUP BY d_id
 					 HAVING COUNT(*) > 0);


 					
-- Задание 2

-- Подсчитать процент суммы сделки от суммы сделок по клиенту (найти «вес» сделки)

SELECT 
	u.name, 
	c.d_number, 
	to_char(o.dt, 'dd.mm.yyyy') as dt, 
	o.summa,
	to_char(o.summa * 100 / SUM(o.summa) OVER(PARTITION BY u.name), '999%') AS perc
FROM users u 
	JOIN contracts c ON u.client_id = c.client_id 
	JOIN operations o ON c.d_id = o.d_id
ORDER BY u.name DESC;



-- Задание 3

-- Сумму сделок нарастающим итогом по дате в разрезе клиентов

SELECT 
	u.name,  
	to_char(o.dt, 'dd.mm.yyyy') as dt, 
	o.summa,
	SUM(o.summa) OVER(PARTITION BY u.name ORDER BY o.dt) AS perc
FROM users u 
	JOIN contracts c ON u.client_id = c.client_id 
	JOIN operations o ON c.d_id = o.d_id;

-- Но если сделки проходили в один день, как в примере, мы можем увидеть не совсем корректный ответ.
-- Как вариант, можно добавить в сортировку d_id и тогда мы увидим нарастающим итогом даже когда сделки были в один день.

SELECT 
	u.name,  
	to_char(o.dt, 'dd.mm.yyyy') as dt, 
	o.summa,
	SUM(o.summa) OVER(PARTITION BY u.name ORDER BY o.dt, c.d_id) AS perc
FROM users u 
	JOIN contracts c ON u.client_id = c.client_id 
	JOIN operations o ON c.d_id = o.d_id;



-- Задание 4

-- А.Сумма по месяцам (поворот таблицы Т из задания 1.А)

SELECT * FROM crosstab('SELECT 
	u.name,  
	to_char(o.dt, ''Mon'') as dt, 
	sum(o.summa)
FROM users u 
	JOIN contracts c ON u.client_id = c.client_id 
	JOIN operations o ON c.d_id = o.d_id
group by u.name, to_char(o.dt, ''Mon'')
order by 1', 'values (''May''), (''Jun''), (''Jul''), (''Aug'')') as ct(name varchar, Май numeric , Июнь numeric , Июль numeric , Август numeric)
order by name desc;


-- Б. Поворот таблицы

SELECT 
	t.nm, 
	tc.quart, 
	tc.val
FROM table_crosstab t
CROSS JOIN LATERAL(
	VALUES
		(t.q1, 'Q1'),
		(t.q2, 'Q2'),
		(t.q3, 'Q3'),
		(t.q4, 'Q4')
) AS tc (val, quart)
ORDER BY nm, quart; 



-- Задание 5

-- А. Вывести структуру подразделений

WITH RECURSIVE structure AS (
    SELECT 
        id,
        pid,
        title,
        title AS root,
        cast ('/' || title as varchar (100)) AS path
    FROM 
        podr
    WHERE 
        pid IS NULL 

    UNION ALL

    SELECT
        d.id,
        d.pid,
        d.title,
        s.root,
        cast (s.path || '/' || d.title as varchar(100)) AS path
    FROM 
        podr d
    INNER JOIN 
        structure s ON d.pid = s.id
)

SELECT 
    path as "FULL_PATH",
    title AS "TITLE",
    root AS "ROOT"
FROM 
    structure
ORDER BY 
    path;

   
-- Б.

-- Написать запрос выводящий цифры от 1 до 100 в один столбец

WITH RECURSIVE numbers_cte AS (
  SELECT 1 AS number
  UNION ALL
  SELECT number + 1
  FROM numbers_cte
  WHERE number < 100
)
SELECT number
FROM numbers_cte;


-- Написать запрос выводящий даты от текущей на 1 год вперед в один столбец

WITH RECURSIVE dates_cte AS (
  SELECT CURRENT_TIMESTAMP AS dt
  UNION ALL
  SELECT dt + INTERVAL '1' DAY
  FROM dates_cte
  WHERE dt < CURRENT_TIMESTAMP + INTERVAL '1' YEAR
)
SELECT dt::date
FROM dates_cte;



-- Задание 1.

-- Напишите SQL выполняющий декартово произведение двух таблиц (T1 и T2)

SELECT * FROM T1 CROSS JOIN T2;



-- Задание 2. Есть таблица, состоящая из одного поля VALUE. Значения в столбце идут вперемешку и могут повторяться. Как с помощью SQL-запроса выбрать из таблицы все повторяющиеся записи.

SELECT 
	value, 
	COUNT(*) AS count 
FROM T1
GROUP BY value
HAVING COUNT(*) > 1;



-- Задание 3. Есть таблица курсов валют ЦБ, состоящая из трех полей: CODE[ISO код валюты],  VALUE[Значение курса], DATE_C[Дата начала действия курса]. 
-- Данные в нее записываются каждый раз при изменении курса какой-либо валюты. Задача: получить курс валюты «USD» на заданную дату.

SELECT
	code, 
	value 
FROM t_currency
WHERE code = 'USD' AND date_c = '2024-06-26';



-- Задание 4. Даны две таблицы, 

SELECT * FROM table1 UNION SELECT * FROM table2;

-- Будет ли работать запрос? Правильно ли полагать, что запрос вернет три строки?

-- Ответ: да, запрос будет работать. UNION используется для объединения результатов двух или более SELECT запросов в один набор данных.
-- Основное требование при объединении: SELECT запросы должны иметь одинаковое количество столбцов и соответствовать типам данных в этих столбцах.
-- Данный запрос вернет уникальные строки. Если мы хотим вернуть все строки, то лучше использовать UNION ALL.



-- Задание 5.
-- Есть бизнес-сущности Студенты и Занятия. Каждый студент может посещать несколько занятий. 
-- Названия занятий и имена студентов - произвольны. Создать физическую ER-модель данных и написать два SQL-запроса:

-- 1. отобразить количество занятий, на которые ходит более 5 студентов

SELECT COUNT(count) AS count_lesson 
FROM (SELECT COUNT(student_id) AS count
FROM student_lesson 
GROUP BY lesson_id
HAVING COUNT(student_id) > 5) AS t;

-- 2. отобразить все занятий, на которые записан определенный студент

SELECT l.title
FROM student s
	JOIN student_lesson sl ON s.student_id = sl.student_id
	JOIN lesson l ON sl.lesson_id = l.lesson_id
WHERE s.name = 'Никита';



-- Задание 6.
-- Дана таблица (Table3), содержащая объем закупок на начало каждого месяца

SELECT
    MAX(CASE WHEN value_date = '2013-03-01' THEN value END) AS TO_MARCH,
    MAX(CASE WHEN value_date = '2013-04-01' THEN value END) AS TO_APRIL,
    MAX(CASE WHEN value_date = '2013-05-01' THEN value END) AS TO_MAY
FROM table3;

select * from podr;

