# PostgreSQL

## Introduction to SQL

- CREATE TABLE r (A1 D1, A2 D2, ..., An Dn, Integrity Constraints);
- SELECT A1, A2, ..., An FROM r1, r2, ..., rm WHERE P;
- SELECT DISTINCT A, SELECT * 
- String Operation : %(any substring), _(any character)
- ORDER BY (desc)
- BETWEEN -> where salary between 90000 and 100000
- Set Operations : union, intersect, except
- NULL values
- Aggregate Functions : avg, min, max, sum, count
- GROUP BY, HAVING Clause
- Set Memberships : IN, NOT IN
- Set Comparisons : some, all, exists, not exists
- UNIQUE, WITH Clause
- Deletion -> delete from r where P
- Insertion -> insert into r values (A1, A2, ...)
- Update : update r set {command} where P

## Intermediate SQL

- Join Types : inner join, left outer join, right outer join, full outer join
- Join Conditions : natural, on <predicate>, using (A1, A2, ..., An)