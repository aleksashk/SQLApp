create table author
(
    id         serial primary key,
    first_name varchar(128) not null,
    last_name  varchar(128) not null
);

create table book
(
    id        bigserial primary key,
    name      varchar(128),
    year      smallint not null,
    pages     smallint not null,
    author_id int references author (id) on delete cascade
);

drop table book;

insert into author(first_name, last_name)
VALUES ('Key', 'Horstmann'),
       ('Steven', 'Covi'),
       ('Tony', 'Robbins'),
       ('Napoleon', 'Hill'),
       ('Robert', 'Kijosaki'),
       ('Dail', 'Cornegi');

select *
from author;

insert into book(name, year, pages, author_id)
VALUES ('Java 1', 2010, 1120, (select id from author where last_name = 'Horstmann')),
       ('Java 2', 2020, 870, (select id from author where last_name = 'Hill')),
       ('Java SE 8', 2000, 560, (select id from author where last_name = 'Horstmann')),
       ('7 Habbits..', 2010, 1120, (select id from author where last_name = 'Horstmann')),
       ('Wake up yourself..', 2007, 2720, (select id from author where last_name = 'Covi')),
       ('Think and become..', 1998, 561, (select id from author where last_name = 'Robbins')),
       ('Rich father...', 1995, 340, (select id from author where last_name = 'Kijosaki')),
       ('How to stop..', 1984, 280, (select id from author where last_name = 'Cornegi')),
       ('How to victory ..', 2022, 780, (select id from author where last_name = 'Cornegi'));

delete
from book
where year > 1800;

select *
from book;

-- 1.

select name, year, first_name
from book
         join author a on a.id = book.author_id
order by year;

select name, year, first_name
from book
         join author a on a.id = book.author_id
order by year desc;

-- 1.2.
select name, year, (select first_name from author where author.id = book.author_id)from book order by year;
select name, year, (select first_name from author where author.id = book.author_id)from book order by year desc;


-- 2.

select count(id) from book where author_id = 1;

-- 2.1

select count(*) from book where author_id=(select id from author where last_name = 'Hill');

-- 3. Написать запрос, выбирающий книги, у которых количество страниц больше среднего количества страниц по всем книгам
-- select avg(pages) from book;
select * from book where pages > (select avg(pages) from book);

-- 4. Написать запрос, который выбирает 5 самых старых книг. Дополнить запрос и посчитать суммарное количество страниц среди этих книг

select sum(pages) from (select pages from book order by year limit 5) al;

-- 5. написать запрос, который меняет количество страниц у одной из книг
update book set pages = 4 where name='Java SE 8' returning *;
update book set pages = 1000 where  id=12 returning *;

-- 6.Написать запрос, который удаляет автора, который написал самую большую книгу

delete from book where author_id = (select author_id from book where pages=(select max(pages) from book));


select pages from book;
select * from book order by pages desc limit 1;
delete from author where id = (select author_id from book order by pages desc limit 1);

select max(pages) from book;
select author_id from book where pages=(select max(pages) from book);
delete from author where id = (select author_id from book where pages=(select max(pages) from book));

select * from book;



