/* Create Table Construct */
create table instructor (
    ID              char(5),
    name            varchar(20),
    dept_name       varchar(20),
    salary          numeric(8,2)
);

/* Integrity Constraints in Create Table

primary key (A1, A2, ... , An)
foreign key (Am, ... , An) references r
not null

*/

create table instructor (
    ID              char(5),
    name            varchar(20) not null,
    dept_name       varchar(20),
    salary          numeric(8,2),
    primary key (ID),
    foreign key (dept_name) references department
);

create table takes (
    ID              varchar(5),
    course_id       varchar(8),
    sec_id          varchar(8),
    semester        varchar(6),
    year            numeric(4,0),
    grade           varchar(2),
    primary key (ID, course_id, sec_id, semester, year),
    foreign key (ID) references student,
    foreign key (course_id, sec_id, semester, year) references section
);

/* Updates to tables */
insert into instructor values ('10211', 'Smith', 'Biology', 66000);

delete from student;

drop table r;

alter table r add A D;
alter table r drop A;

/*

select A1, A2, ..., An
from r1, r2, ..., rm
where P;

*/

/* SELECT CLAUSE */
SELECT DISTINCT dept_name
FROM instructor;

SELECT ALL dept_name
FROM instructor;

SELECT * /* select all attributes */
FROM instructor;

SELECT ID, name, salary/12
FROM instructor;

SELECT ID, name, salary/12 as monthly_salary
FROM instructor;

/* WHERE CLAUSE */
SELECT name
FROM instructor
WHERE dept_name = 'Comp. Sci.';

SELECT name
FROM instructor
WHERE dept_name = 'Comp. Sci.' and salary > 70000;

/* FROM CLAUSE */
SELECT *
FROM instructor, teaches;

SELECT name, course_id
FROM instructor, teaches
WHERE instructor.ID = teaches.ID;

SELECT name, course_id
FROM instructor, teaches
WHERE instructor.ID = teaches.ID and instructor.dept_name = 'Art';

/* RENAME OPERATION */
SELECT DISTINCT T.name
FROM instructor as T, instructor as S
WHERE T.salary > S.salary and S.dept_name = 'Comp. Sci.';

/* 
String Operations 

percent(%) : any substring
underscore(_) : any character

*/

SELECT name
FROM instructor
WHERE name like '%dar%';

/* Ordering the Display of Tuples */
SELECT DISTINCT name
FROM instructor
ORDER BY name;

ORDER BY name desc /* 거꾸로 */

/* between comparison operator */
SELECT name
FROM instructor
WHERE salary BETWEEN 90000 and 100000;

SELECT name, course_id
FROM instructor, teaches
WHERE (instructor.ID, dept_name) = (teaches.ID, 'Biology');

/* Set Operations : UNION, INTERSECT, EXCEPT 중복 허용 : UNION ALL, INTERSECT ALL, EXCEPT ALL */
(SELECT course_id FROM section WHERE sem='Fall' and year = 2017)
UNION
(SELECT course_id FROM section WHERE sem='Spring' and year = 2018)

(SELECT course_id FROM section WHERE sem='Fall' and year = 2017)
INTERSECT
(SELECT course_id FROM section WHERE sem='Spring' and year = 2018)

(SELECT course_id FROM section WHERE sem='Fall' and year = 2017)
EXCEPT
(SELECT course_id FROM section WHERE sem='Spring' and year = 2018)

/* NULL Values */
SELECT name
FROM instructor
WHERE salary IS NULL;

/* Aggregate Functions  : avg, min, max, sum, count */
SELECT avg (salary)
FROM instructor
WHERE dept_name = 'Comp. Sci.';

SELECT count (DISTINCT ID)
FROM teaches
WHERE semester = 'Spring' and year = 2018;

SELECT count (*)
FROM course;

/* GROUP BY */
'Find the average salary of instructors in each department'
SELECT dept_name, avg (salary) as avg_salary
FROM instructor
GROUP BY dept_name;

/* erroneous query */
SELECT dept_name, ID, avg (salary)
FROM instructor
GROUP BY dept_name;

/* Having Clause */
'Find the names and average salaries of all departments whose average salary is greater than 42000'
SELECT dept_name, avg (salary) as avg_salary
FROM instructor
GROUP BY dept_name                  /* before forming groups */
HAVING avg (salary) > 42000;        /* after forming groups  */

/* Nested Subqueries */

/* Set Membership */
'Find courses offered in Fall 2017 and in Spring 2018'
SELECT DISTINCT course_id
FROM section
WHERE semester = 'Fall' and year = 2017 and course_id in (SELECT course_id
                                                          FROM section
                                                          WHERE semester = 'Spring' and year = 2018);

'Find courses offered in Fall 2017 but not in Spring 2018'
SELECT DISTINCT course_id
FROM section
WHERE semester = 'Fall' and year = 2017 and course_id not in (SELECT course_id
                                                              FROM section
                                                              WHERE semester = 'Spring' and year = 2018);

'Name all instructor whose name is neither "Mozart" nor "Einstein"'
SELECT DISTINCT name
FROM instructor
WHERE name not in ('Mozart', 'Einstein');

'Find the total number of (distinct) students who have taken course sections taught by the instructor with ID 10101'
SELECT COUNT (DISTINCT ID)
FROM takes
WHERE (course_id, sec_id, semester, year) in (SELECT course_id, sec_id, semester, year
                                              FROM teaches
                                              WHERE teaches.ID = 10101);

/* Set Comparison */
/* "some" Clause */
'Find names of instructors with salary greater than that of some (at least one) instructor in the Biology department.'
SELECT DISTINCT T.name
FROM instructor as T, instructor as S
WHERE T.salary > S.salary and S.dept_name = 'Biology';

SELECT name
FROM instructor
WHERE salary > SOME (SELECT salary
                     FROM instructor
                     WHERE dept_name = 'Biology');

/* "all" Clause */
'Find the names of all instructors whose salary is greater than the salary of all instructors in the Biology department'
SELECT name
FROM instructor
WHERE salary > all (SELECT salary
                    FROM instructor
                    WHERE dept_name = 'Biology');

/* exists */
'Find all courses taught in both the Fall 2017 semester and in the Spring 2018 semester'
SELECT course_id
FROM section as S
WHERE semester = 'Fall' and year = 2017 and exists (SELECT *
                                                    FROM section as Table
                                                    WHERE semester = 'Spring' and year = 2018 and S.course_id = T.course_id)

/* not exists */
'Find all students who have taken all courses offered in the Biology department'
SELECT DISTINCT S.ID S.name
FROM student as S
WHERE not exists ((SELECT course_id
                   FROM course
                   WHERE dept_name = 'Biology')
                  EXCEPT
                  (SELECT T.course_id
                   FROM takes as T
                   WHERE S.ID = T.ID));

/* Test for Absence of Duplicate Tuples */
'Find all courses that were offered at most once in 2017'
SELECT T.course_id
FROM course as T
WHERE unique (SELECT R.course_id
              FROM section as R
              WHERE T.coursed_id = R.course_id and R.year = 2017);

/* Subqueries in the Form Clause */
"Find the average instructors' salaries of those department where the average salary is greater than $42000"
SELECT dept_name, avg_salary
FROM (SELECT dept_name, avg(salary) as avg_salary
      FROM instructor
      GROUP BY dept_name)
WHERE avg_salary > 42000;

/* With Clause */
'Find all departments with the maximum budget'
with max_budget (value) as
    (select max(budget)
     from department)
select department.name
from departmentm, max_budget
where department.budget = max_budget.value;

/* Complex Queries using With Clause */
'Find all departments where the total salary is greater than the average of the total salary at all departments'
with dept_total (dept_name, value) as
    (select dept_name, sum(salary)
     from instructor
     group by dept_name),
    dept_total_avg (value) as
    (select avg(value)
     from dept_total)
select dept_name
from dept_total, dept_total_avg
where dept_total.value > dept_total_avg.value;

/* Scalar Subquery */
'List all departments along with the number of instructors in each department'
select dept_name, (select count(*)
                   from instructor
                   where department.dept_name = instructor.dept_name)
                as num_instructors
from department;

/* Modification of the Database */
/* Deletion */
'Delete all instructors'
delete from instructor;

'Delete all instructors from the Finance department'
delete from instructor
where dept_name = 'Finance';

'Delete all tuples in the instructor relation for those instructors associated with a department located in the Watson building'
delete from instructor
where dept_name in (select dept_name
                    from department
                    where building = 'Watson');

'Delete all instructors whose salary is less than the average salary of instructors'
delete from instructor
where salary < (select avg(salary) from instructor);

/* Insertion */
insert into course values ('CS-437', 'Database Systems', 'Comp. Sci.', 4);

'Make each student in the Music department who has earned more than 144 credit hours an instructor in the Music department with a salary of $18000'
insert into instructor
    select ID, name, dept_name, 18000
    from student
    where dept_name = 'Music' and total_cred > 144;

/* Updates */
'Give a 5% salary raise to all instructors'
update instructor
set salary = salary * 1.05

'Give a 5% salary raise to those instructors who earn less than 70000'
update instructor
set salary = salary * 1.05
where salary < 70000;

'Give a 5% salary raise to instructors whose salary is less than average'
update instructor
set salary = salary * 1.05
where salary < (select avg(salary) from instructor);

'Increase salaries of instructors whose salary is over $100000 by 3%, and all others by a 5%'
update instructor
    set salary = salary * 1.03
    where salary > 100000
update instructor
    set salary = salary * 1.05
    where salary <= 100000

'Recompute and update tot_creds value for all students'
update student S
set tot_cred = (select sum(credits)
                from takes, course
                where takes.course_id = course.course_id and S.ID = takes.ID and takes.grade <> 'F' and takes.grade is not null)
