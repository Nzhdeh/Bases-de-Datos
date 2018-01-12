--Escribe el c�digo SQL necesario para realizar las siguientes operaciones
--sobre la base de datos "pubs�

use pubs
go

--1. Numero de libros que tratan de cada tema
--select * from titles
select [type],count (title_id) as [Numero de libros que tratan de cada tema] from titles
group by [type]
go

--2. N�mero de autores diferentes en cada ciudad y estado
--select * from authors
select city,[state],count(au_id) as [Numero de autores diferentes en cada ciudad y estado] from authors
group by city,[state]
go

--3. Nombre, apellidos, nivel y antig�edad en la empresa de los empleados con un nivel entre 100 y 150.
--select * from employee
select fname,lname,job_lvl,year(current_timestamp-(hire_date))-1900 as [Antiguedad] from employee
where job_lvl between 100 and 150
go

--4. N�mero de editoriales en cada pa�s. Incluye el pa�s.
--select * from publishers
--select country,count(*) as [Numero de editoriales en cada pais] from publishers
select country,count(pub_id) as [Numero de editoriales en cada pais] from publishers
group by country
go

--5. N�mero de unidades vendidas de cada libro en cada a�o (title_id, unidades y a�o).
--select * from titles
select title_id,pubdate,count(pub_id) as [Numero de unidades vendidas cada a�o] from titles
group by title_id,pubdate/*************************/
go

--6. N�mero de autores que han escrito cada libro (title_id y numero de autores).
--select * from titles
select title_id,count(*) as [Numero de autores] from titles
group by title_id/*****************************/
go

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000,
-- ordenado por tipo y t�tulo
--select * from titles
select title_id,title,[type],price,advance from titles
where advance>7000
group by title_id,title,[type],price,advance
order by title,[type]
go