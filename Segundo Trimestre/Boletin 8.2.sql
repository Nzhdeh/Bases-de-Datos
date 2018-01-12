--Escribe el código SQL necesario para realizar las siguientes operaciones
--sobre la base de datos "pubs”

use pubs
go

--1. Numero de libros que tratan de cada tema
--select * from titles
select [type],count (title_id) as [Numero de libros que tratan de cada tema] from titles
group by [type]
go

--2. Número de autores diferentes en cada ciudad y estado
--select * from authors
select city,[state],count(au_id) as [Numero de autores diferentes en cada ciudad y estado] from authors
group by city,[state]
go

--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.
--select * from employee
select fname,lname,job_lvl,year(current_timestamp-(hire_date))-1900 as [Antiguedad] from employee
where job_lvl between 100 and 150
go

--4. Número de editoriales en cada país. Incluye el país.
--select * from publishers
--select country,count(*) as [Numero de editoriales en cada pais] from publishers
select country,count(pub_id) as [Numero de editoriales en cada pais] from publishers
group by country
go

--5. Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).
--select * from titles
select title_id,pubdate,count(pub_id) as [Numero de unidades vendidas cada año] from titles
group by title_id,pubdate/*************************/
go

--6. Número de autores que han escrito cada libro (title_id y numero de autores).
--select * from titles
select title_id,count(*) as [Numero de autores] from titles
group by title_id/*****************************/
go

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000,
-- ordenado por tipo y título
--select * from titles
select title_id,title,[type],price,advance from titles
where advance>7000
group by title_id,title,[type],price,advance
order by title,[type]
go