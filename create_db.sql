-- Таблицы для задания 1, 2, 3, 4

CREATE TABLE IF NOT EXISTS users(
	client_id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS contracts(
	d_id SERIAL PRIMARY KEY,
	client_id INTEGER,
	d_number VARCHAR(100),
	FOREIGN KEY(client_id) REFERENCES users(client_id)
);

CREATE TABLE IF NOT EXISTS operations(
	id_op SERIAL PRIMARY KEY,
	d_id INTEGER,
	dt DATE,
	summa NUMERIC,
	FOREIGN KEY(d_id) REFERENCES contracts(d_id)
);



-- Таблица для задания 4Б

CREATE TABLE IF NOT EXISTS table_crosstab(
	nm VARCHAR(5) PRIMARY KEY,
	q1 INTEGER,
	q2 INTEGER,
	q3 INTEGER,
	q4 INTEGER
);



-- Таблица для задания 5 - рекурсия

CREATE TABLE IF NOT EXISTS podr(
	id SERIAL PRIMARY KEY,
	pid INTEGER,
	title VARCHAR(100)
);



-- Таблицы для задания 4Б

CREATE TABLE IF NOT EXISTS table1(
	column1 INTEGER,
	column2 INTEGER
);

CREATE TABLE IF NOT EXISTS table2(
	column1 INTEGER,
	column2 INTEGER
);



-- Таблицы для задания 5

CREATE TABLE IF NOT EXISTS student(
	student_id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS lesson(
	lesson_id SERIAL PRIMARY KEY,
	title VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS student_lesson(
	sl_id SERIAL PRIMARY KEY,
	student_id INTEGER,
	lesson_id INTEGER,
	FOREIGN KEY(student_id) REFERENCES student(student_id),
	FOREIGN KEY(lesson_id) REFERENCES lesson(lesson_id)
);



-- Таблица для задания 6	

CREATE TABLE IF NOT EXISTS table3(
	value_date DATE,
	value INTEGER);
	
