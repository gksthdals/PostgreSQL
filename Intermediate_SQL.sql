/* Join Expressions */
/* Natural join, Inner join, Outer join */
'List the names of instructors along with the course ID of the courses that they taught'
    select name, course_id
    from students, takes
    where student.id = takes.id;

    select name, course_id
    from student natural join takes;

'List the names of students along with the titles of courses that they have taken'
    select name, title
    from student natural join takes, course
    where takes.course_id = course.course_id;

    select name, title
    from (student natural join takes) join course using (course_id);

/*

left outer join
right outer join
full outer join

*/

/* Join Types */
'inner join / left outer join / right outer join / full outer join'

/* Join conditions */
'natural : 중복 X, on <predicate> : 중복 O, using (A1, A2, ..., An) : 중복 X'

/* Views */


/* Transactions */


/* Integrity Constraints */

