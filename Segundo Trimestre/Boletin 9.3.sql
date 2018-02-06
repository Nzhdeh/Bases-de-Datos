--Escribe las siguientes consultas sobre la base de datos pubs.
use pubs
go

--1. Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).
select distinct T.title,T.[type] from authors as A 
inner join titleauthor as TA on A.au_id=A.au_id
inner join titles as T on TA.title_id=T.title_id
where A.[state]='CA'
go

--2. Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
select T.title,T.[type] from titles as T
except
select T.title,T.[type] from authors as A 
inner join titleauthor as TA on A.au_id=A.au_id
inner join titles as T on TA.title_id=T.title_id
where A.[state]='CA'
go

--3. Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
select A.au_id,A.au_fname,A.au_lname,count(TA.title_id) as [Cantidad de libros] from titleauthor as TA
right join authors as A on TA.au_id=A.au_id
group by A.au_id,A.au_fname,A.au_lname
go

--4. Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.
select P.pub_id,P.pub_name,count (T.title_id) as [Numero de libros] from titles as T
right join publishers as P on T.pub_id=P.pub_id
group by P.pub_id,P.pub_name
go
--5. Número de empleados de cada editorial.
select P.pub_id,P.pub_name,count(E.emp_id) as [Numero de empleados] from publishers as P
inner join employee as E on P.pub_id=E.pub_id
group by P.pub_id, P.pub_name
order by P.pub_id
go

--6. Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial, 
--incluyendo el nombre de la misma.
select P.pub_name,(count(T.title_id)/count(E.emp_id)) as [Relacion entre libros publicados y trabajadores] from employee as E
inner join publishers as P on E.pub_id=P.pub_id
inner join titles as T on P.pub_id=T.pub_id
group by P.pub_name
go

--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley” 
--o "Five Lakes Publishing”
select A.au_fname,A.au_lname,A.[state],P.pub_name from authors as A
inner join titleauthor as TA on A.au_id=TA.au_id
inner join titles as T on TA.title_id=T.title_id
inner join publishers as P on T.pub_id=P.pub_id
where P.pub_name in ('Binnet & Hardley','Five Lakes Publishing')
go

--8. Empleados que hayan trabajado en alguna editorial que haya publicado algún libro en el que alguno de 
--los autores fuera Marjorie Green o Michael O'Leary.
select E.fname,E.lname,A.au_fname,A.au_lname from employee as E
inner join publishers as P on E.pub_id=P.pub_id
inner join titles as T on P.pub_id=T.pub_id
inner join titleauthor as TA on T.title_id=TA.title_id
inner join authors as A on TA.au_id=A.au_id
where A.au_fname in ('Marjorie','Michael') and A.au_lname in('Green','O''Leary')
go

--9. Número de ejemplares vendidos de cada libro, especificando el título y el tipo.
select T.title,T.[type],count(S.title_id) as [Ejemplares vendidos] from titles as T
inner join sales as S on T.title_id=S.title_id
group by T.title,T.[type]
go

--10.  Número de ejemplares de todos sus libros que ha vendido cada autor.

--11.  Número de empleados de cada categoría (jobs).

--12.  Número de empleados de cada categoría (jobs) que tiene cada editorial, incluyendo aquellas categorías 
--en las que no haya ningún empleado.

--13.  Autores que han escrito libros de dos o más tipos diferentes

--14.  Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes 
--contenga la palabra "and”

select * from authors
--prueba
insert into authors(au_id,au_lname,au_fname,phone,[address],city,[state],zip,[contract])
values('172-44-1179','Եղիազարյան','Նժդեհ','628-898-108','Jardin del Eden','Sevilla','AN','12346',0)