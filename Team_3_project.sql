 -- Создание базы данных
CREATE DATABASE
  group_project;

-- СОЗДАНИЕ ТАБЛИЦ
-- Таблица курсов 
CREATE TABLE
  course (id SERIAL PRIMARY KEY, course_name VARCHAR(80));

-- Таблица студентов
CREATE TABLE
  student (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    last_name VARCHAR(50),
    UNIQUE (name, last_name)
  );

-- Таблица преподавателей
CREATE TABLE
  teacher (id SERIAL PRIMARY KEY, name VARCHAR(80) UNIQUE);

-- Таблица дисциплин
CREATE TABLE
  discipline (
    id SERIAL PRIMARY KEY,
    title VARCHAR(80),
    course_id INT REFERENCES course (id) ON DELETE CASCADE
  );

-- Связующая таблица студенты-дисциплины
CREATE TABLE
  discipline_student (
    student_id INT REFERENCES student (id) ON DELETE CASCADE,
    discipline_id INT REFERENCES discipline (id) ON DELETE CASCADE,
    grade INT CHECK (grade BETWEEN 1 AND 5),
    PRIMARY KEY (student_id, discipline_id)
  );

-- Связующая таблица преподаватели-дисциплины
CREATE TABLE
  teacher_discipline (
    teacher_id INT REFERENCES teacher (id) ON DELETE CASCADE,
    discipline_id INT REFERENCES discipline (id) ON DELETE CASCADE,
    PRIMARY KEY (teacher_id, discipline_id)
  );

-- ЗАПОЛНЕНИЕ ТАБЛИЦ
-- Заполнение таблицы курсов
INSERT INTO
  course (course_name)
VALUES
  ('Mathematics'),
  ('Programming'),
  ('Communications');

-- Заполнение таблицы дисциплин
INSERT INTO
  discipline (title, course_id)
VALUES
  ('Mathematical Methods', 1),
  ('Linear Algebra', 1),
  ('English', 3),
  ('German', 3),
  ('Philosophy', 3),
  ('Python', 2),
  ('C/C++', 2);

-- Заполнение таблицы студентов
INSERT INTO
  student (name, last_name)
VALUES
  ('John', 'Doe'),
  ('Jane', 'Lane'),
  ('David', 'Martinez'),
  ('Micaella', 'Dowson'),
  ('Hans', 'Kohl'),
  ('Elke', 'Shickert'),
  ('Maria', 'Karrey');

-- Заполнение таблицы преподавателей 
INSERT INTO
  teacher (name)
VALUES
  ('Einstein'),
  ('Laplace'),
  ('Shakespeare'),
  ('Goethe'),
  ('Schopenhauer'),
  ('Stroustrup'),
  ('Van Rossum'),
  ('D Alembert');

-- Заполнение связующей таблицы дисциплины-студенты
INSERT INTO
  discipline_student (student_id, discipline_id, grade)
VALUES
  (1, 1, 5),
  (1, 2, 5),
  (1, 3, 4),
  (1, 4, 4),
  (1, 5, 3),
  (1, 6, 4),
  (1, 7, 5),
  (2, 1, 4),
  (2, 2, 3),
  (2, 6, 5),
  (2, 7, 5),
  (3, 3, 5),
  (3, 4, 5),
  (3, 5, 4),
  (4, 6, 3),
  (4, 7, 4),
  (5, 1, 5),
  (5, 2, 4),
  (5, 3, 4);

-- Заполнение связующей таблицы преподаватели-дисциплины
INSERT INTO
  teacher_discipline (teacher_id, discipline_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5),
  (6, 6),
  (7, 7);
  
-- ЗАПРОСЫ 

-- сколько студентов на каждой дисциплине?
SELECT d.title AS discipline, COUNT(d_s.student_id) AS student_count
FROM discipline d
JOIN discipline_student d_s ON d.id = d_s.discipline_id
GROUP BY d.title;

-- средняя оценка по каждой дисциплине курса
SELECT d.title AS discipline, ROUND(AVG(d_s.grade), 0) AS avg_grade
FROM discipline d
JOIN discipline_student d_s ON d.id = d_s.discipline_id
GROUP BY d.title;

-- средняя оценка по каждому курсу
SELECT c.course_name, ROUND(AVG(d_s.grade), 0) AS avg_grade
FROM course c
JOIN discipline d ON c.id = d.course_id
JOIN discipline_student d_s ON d.id = d_s.discipline_id
GROUP BY c.course_name;

-- сколько студентов у каждого преподавателя?
SELECT t.name AS teacher, COUNT(DISTINCT d_s.student_id) AS students_count
FROM teacher t
JOIN teacher_discipline t_d ON t.id = t_d.teacher_id
JOIN discipline_student d_s ON t_d.discipline_id = d_s.discipline_id
GROUP BY t.name;

-- cколько студентов на каждом курсе?
SELECT c.course_name, COUNT(DISTINCT d_s.student_id) AS student_count
FROM course c
JOIN discipline d ON c.id = d.course_id
JOIN discipline_student d_s ON d.id = d_s.discipline_id
GROUP BY c.course_name;

-- рабочие показатели преподавателей!
SELECT t.name AS teacher, ROUND(AVG(d_s.grade), 2) AS students_average_grade,
COUNT(DISTINCT d_s.student_id) AS student_count
FROM teacher t
JOIN teacher_discipline t_d ON t.id = t_d.teacher_id
JOIN discipline_student d_s ON t_d.discipline_id = d_s.discipline_id
GROUP BY t.name;
