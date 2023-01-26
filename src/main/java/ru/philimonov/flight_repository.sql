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
select name, year, (select first_name from author where author.id = book.author_id)
from book
order by year;
select name, year, (select first_name from author where author.id = book.author_id)
from book
order by year desc;


-- 2.

select count(id)
from book
where author_id = 1;

-- 2.1

select count(*)
from book
where author_id = (select id from author where last_name = 'Hill');

-- 3. Написать запрос, выбирающий книги, у которых количество страниц больше среднего количества страниц по всем книгам
-- select avg(pages) from book;
select *
from book
where pages > (select avg(pages) from book);

-- 4. Написать запрос, который выбирает 5 самых старых книг. Дополнить запрос и посчитать суммарное количество страниц среди этих книг

select sum(pages)
from (select pages from book order by year limit 5) al;

-- 5. написать запрос, который меняет количество страниц у одной из книг
update book
set pages = 4
where name = 'Java SE 8'
returning *;
update book
set pages = 1000
where id = 12
returning *;

-- 6.Написать запрос, который удаляет автора, который написал самую большую книгу

delete
from book
where author_id = (select author_id from book where pages = (select max(pages) from book));


select pages
from book;
select *
from book
order by pages desc
limit 1;
delete
from author
where id = (select author_id from book order by pages desc limit 1);

select max(pages)
from book;
select author_id
from book
where pages = (select max(pages) from book);
delete
from author
where id = (select author_id from book where pages = (select max(pages) from book));

select *
from book;


create database flight_repository;

create table airport
(
    code    char(3) primary key,
    country varchar(256),
    city    varchar(256)
);

create table aircraft
(
    id    serial primary key,
    model varchar(128) not null
);

create table seat
(
    aircraft_id int references aircraft (id),
    seat_no     varchar(4) not null,
    primary key (aircraft_id, seat_no)
);

create table flight
(
    id                     bigserial primary key,
    flight_no              varchar(16)                       not null,
    departure_date         timestamp                         not null,
    departure_airport_code char(3) references airport (code) not null,
    arrival_date           timestamp                         not null,
    arrival_airport_code   char(3) references airport (code) not null,
    aircraft_id            int references aircraft (id)      not null,
    status                 varchar(32)                       not null
);

create table ticket
(
    id             bigserial primary key,
    passenger_no   varchar(32)                   not null,
    passenger_name varchar(128)                  not null,
    flight_id      bigint references flight (id) not null,
    seat_no        varchar(4)                    not null,
    cost           numeric(8, 2)                 not null
);


CREATE UNIQUE INDEX unique_flight_id_seat_no_idx ON ticket (flight_id, seat_no);
-- flight_id + seat_no

select *
from ticket
where seat_no = 'B1'
  and flight_id = 5;

select count(distinct flight_id)
from ticket;
select count(*)
from ticket;
-- 9 / 55
-- 55 / 55 = 1
-- 55 / 55 = 1


insert into airport (code, country, city)
values ('MNK', 'Беларусь', 'Минск'),
       ('LDN', 'Англия', 'Лондон'),
       ('MSK', 'Россия', 'Москва'),
       ('BSL', 'Испания', 'Барселона');

insert into aircraft (model)
values ('Боинг 777-300'),
       ('Боинг 737-300'),
       ('Аэробус A320-200'),
       ('Суперджет-100');

insert into seat (aircraft_id, seat_no)
select id, s.column1
from aircraft
         cross join (values ('A1'), ('A2'), ('B1'), ('B2'), ('C1'), ('C2'), ('D1'), ('D2') order by 1) s;

insert into flight (flight_no, departure_date, departure_airport_code, arrival_date, arrival_airport_code, aircraft_id,
                    status)
values ('MN3002', '2020-06-14T14:30', 'MNK', '2023-01-14T18:07', 'LDN', 1, 'ARRIVED'),
       ('MN3002', '2020-06-16T09:15', 'LDN', '2023-01-16T13:00', 'MNK', 1, 'ARRIVED'),
       ('BC2801', '2020-07-28T23:25', 'MNK', '2023-01-29T02:43', 'LDN', 2, 'ARRIVED'),
       ('BC2801', '2020-08-01T11:00', 'LDN', '2023-01-01T14:15', 'MNK', 2, 'DEPARTED'),
       ('TR3103', '2020-05-03T13:10', 'MSK', '2023-01-03T18:38', 'BSL', 3, 'ARRIVED'),
       ('TR3103', '2020-05-10T07:15', 'BSL', '2023-01-10T012:44', 'MSK', 3, 'CANCELLED'),
       ('CV9827', '2020-09-09T18:00', 'MNK', '2023-01-09T19:15', 'MSK', 4, 'SCHEDULED'),
       ('CV9827', '2020-09-19T08:55', 'MSK', '2023-01-25T10:05', 'MNK', 4, 'SCHEDULED'),
       ('QS8712', '2023-01-25T03:35', 'MNK', '2023-01-25T06:46', 'LDN', 2, 'ARRIVED');

insert into ticket (passenger_no, passenger_name, flight_id, seat_no, cost)
values ('112233', 'Иван Иванов', 1, 'A1', 200),
       ('23234A', 'Петр Петров', 1, 'B1', 180),
       ('SS988D', 'Светлана Светикова', 1, 'B2', 175),
       ('QYASDE', 'Андрей Андреев', 1, 'C2', 175),
       ('POQ234', 'Иван Кожемякин', 1, 'D1', 160),
       ('898123', 'Олег Рубцов', 1, 'A2', 198),
       ('555321', 'Екатерина Петренко', 2, 'A1', 250),
       ('QO23OO', 'Иван Розмаринов', 2, 'B2', 225),
       ('9883IO', 'Иван Кожемякин', 2, 'C1', 217),
       ('123UI2', 'Андрей Буйнов', 2, 'C2', 227),
       ('SS988D', 'Светлана Светикова', 2, 'D2', 277),
       ('EE2344', 'Дмитрий Трусцов', 3, 'А1', 300),
       ('AS23PP', 'Максим Комсомольцев', 3, 'А2', 285),
       ('322349', 'Эдуард Щеглов', 3, 'B1', 99),
       ('DL123S', 'Игорь Беркутов', 3, 'B2', 199),
       ('MVM111', 'Алексей Щербин', 3, 'C1', 299),
       ('ZZZ111', 'Денис Колобков', 3, 'C2', 230),
       ('234444', 'Иван Старовойтов', 3, 'D1', 180),
       ('LLLL12', 'Людмила Старовойтова', 3, 'D2', 224),
       ('RT34TR', 'Степан Дор', 4, 'A1', 129),
       ('999666', 'Анастасия Шепелева', 4, 'A2', 152),
       ('234444', 'Иван Старовойтов', 4, 'B1', 140),
       ('LLLL12', 'Людмила Старовойтова', 4, 'B2', 140),
       ('LLLL12', 'Роман Дронов', 4, 'D2', 109),
       ('112233', 'Иван Иванов', 5, 'С2', 170),
       ('NMNBV2', 'Лариса Тельникова', 5, 'С1', 185),
       ('DSA586', 'Лариса Привольная', 5, 'A1', 204),
       ('DSA583', 'Артур Мирный', 5, 'B1', 189),
       ('DSA581', 'Евгений Кудрявцев', 6, 'A1', 204),
       ('EE2344', 'Дмитрий Трусцов', 6, 'A2', 214),
       ('AS23PP', 'Максим Комсомольцев', 6, 'B2', 176),
       ('112233', 'Иван Иванов', 6, 'B1', 135),
       ('309623', 'Татьяна Крот', 6, 'С1', 155),
       ('319623', 'Юрий Дувинков', 6, 'D1', 125),
       ('322349', 'Эдуард Щеглов', 7, 'A1', 69),
       ('DIOPSL', 'Евгений Безфамильная', 7, 'A2', 58),
       ('DIOPS1', 'Константин Швец', 7, 'D1', 65),
       ('DIOPS2', 'Юлия Швец', 7, 'D2', 65),
       ('1IOPS2', 'Ник Говриленко', 7, 'C2', 73),
       ('999666', 'Анастасия Шепелева', 7, 'B1', 66),
       ('23234A', 'Петр Петров', 7, 'C1', 80),
       ('QYASDE', 'Андрей Андреев', 8, 'A1', 100),
       ('1QAZD2', 'Лариса Потемнкина', 8, 'A2', 89),
       ('5QAZD2', 'Карл Хмелев', 8, 'B2', 79),
       ('2QAZD2', 'Жанна Хмелева', 8, 'С2', 77),
       ('BMXND1', 'Светлана Хмурая', 8, 'В2', 94),
       ('BMXND2', 'Кирилл Сарычев', 8, 'D1', 81),
       ('SS988D', 'Светлана Светикова', 9, 'A2', 222),
       ('SS978D', 'Андрей Желудь', 9, 'A1', 198),
       ('SS968D', 'Дмитрий Воснецов', 9, 'B1', 243),
       ('SS958D', 'Максим Гребцов', 9, 'С1', 251),
       ('112233', 'Иван Иванов', 9, 'С2', 135),
       ('NMNBV2', 'Лариса Тельникова', 9, 'B2', 217),
       ('23234A', 'Петр Петров', 9, 'D1', 189),
       ('123951', 'Полина Зверева', 9, 'D2', 234);

select *
from ticket
         join flight f on f.id = ticket.flight_id
where seat_no = 'B1'
  and f.departure_airport_code = 'MNK'
  and f.arrival_airport_code = 'LDN'
  and f.departure_date::date = (now() - interval '1 days')::date;

select * from flight;

select t.flight_id from ticket t join flight f on f.id = t.flight_id where f.flight_no = 'NM3002' and f.departure_date::date = '2023-01-25'::date group by t.flight_id;

select  f.id, f.arrival_date::date, f.departure_date::date, f.arrival_date - f.departure_date from flight f order by (f.arrival_date - f.departure_date) desc ;

select f.id, first_value(f.arrival_date - f.departure_date) over ( order by (f.arrival_date - f.departure_date)) from flight f
                                                                                                                          join airport a on f.arrival_airport_code = a.code
                                                                                                                          join airport d on f.departure_airport_code = d.code
where a.city='Лондон'
  and d.city='Минск';



select t.passenger_name, count(*), round(100.0 * count(*) / (select count(*) from ticket) - count(*),2)
from ticket t
group by t.passenger_name
order by 2 desc;