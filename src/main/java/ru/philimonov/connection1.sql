select company.name || ' -> ' || employee.last_name fio from employee, company;

select * from company;

insert into company values (1, 'Google', '1999-01-01');

select * from company order by id;

select e.first_name, e.last_name, e.salary, c.name, c.date from employee e join company c on c.id = e.company_id;


select c.name, e.first_name from company c left join employee e on c.id = e.company_id;
select company.name, company.date, count(e.id) from company left join employee e on company.id = e.company_id where company.name = 'Aliexpress' group by company.id;

select * from employee;


select company.name, company.date, count(e.id) from company left join employee e on company.id = e.company_id group by company.id having count(e.id) > 0;

select row_number() over (), lead(2) over(), company.name, e.last_name, count(*) over(), max(e.salary) over(), avg(e.salary) over() from company left join employee e on company.id = e.company_id order by company.name;