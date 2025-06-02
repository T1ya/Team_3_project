CREATE DATABASE group_project;

--add student
CREATE TABLE student (
  id serial PRIMARY KEY,
  name varchar(50),
 	last_name varchar(50)
 );

--fill student
INSERT INTO student (name, last_name) VALUES 
  ('John', 'Doe'),
  ('Jane', 'Lane'),
  ('David', 'Martinez'),
  ('Micaella', 'Dowson'),
  ('Hans', 'Kohl'),
  ('Elke', 'Shickert'),
  ('Maria', 'Karrey')

--add discipline
CREATE TABLE discipline (
  id serial PRIMARY KEY,
  title varchar(80)
  );

--fill discipline list
INSERT INTO discipline (title) VALUES 
('Mathematic methods'),
('Linear algebra'),
('English'),
('German'),
('Philosophy'),
('Python'),
('C/C++')

--binding table discipline_student
CREATE TABLE discipline_student (
  student_id int REFERENCES student(id) ON DELETE CASCADE,
  discipline_id int REFERENCES discipline(id) ON DELETE CASCADE,
  grade int,
  PRIMARY KEY (student_id, discipline_id)
  );
  
--fill binding table discipline_student
INSERT INTO discipline_student(student_id, discipline_id, grade) 
VALUES
(1,1,5),
(1,2,5),
(1,3,4),
(1,4,4),
(1,5,3),
(1,6,4),
--(1,6,5),
(1,7,5);

DROP TABLE discipline_student;

SELECT student.name AS student, discipline.title AS discipline, grade 
FROM discipline_student
JOIN student ON student.id = discipline_student.student_id
JOIN discipline ON discipline.id = discipline_student.discipline_id;



