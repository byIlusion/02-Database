drop database if exists magic_school;
create database magic_school;
use magic_school;
create table faculties(
 id SERIAL PRIMARY KEY,-- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
 name VARCHAR(100)
);

drop table if exists students;
create table students(
	id SERIAL PRIMARY KEY,-- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	name VARCHAR(255),
	faculty_id BIGINT UNSIGNED NOT null,
	FOREIGN KEY(faculty_id) references faculties(id)
);

drop table if exists subjects;
create table subjects(
 id SERIAL PRIMARY KEY,-- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
 name VARCHAR(100)
);

drop table if exists exams;
create table exams(
 student_id BIGINT UNSIGNED NOT null, 
 subject_id BIGINT UNSIGNED NOT null,
 mark INT,
 PRIMARY KEY (student_id, subject_id),
 FOREIGN KEY(student_id) references students(id),
 FOREIGN KEY(subject_id) references subjects(id)
);

drop table if exists pets;
create table pets(
 id SERIAL PRIMARY KEY,-- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
 name VARCHAR(100),
 type VARCHAR(100),
 student_id BIGINT UNSIGNED NOT null, 
 FOREIGN KEY(student_id) references students(id)
);


