--Escribe las siguientes consultas sobre la base de datos pubs.
use pubs
go

--1. T�tulo y tipo de todos los libros en los que alguno de los autores vive en California (CA).
select distinct T.title,T.[type] from authors as A 
inner join titleauthor as TA on A.au_id=A.au_id
inner join titles as T on TA.title_id=T.title_id
where A.[state]='CA'
go

--2. T�tulo y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
select T.title,T.[type] from titles as T
except
select T.title,T.[type] from authors as A 
inner join titleauthor as TA on A.au_id=A.au_id
inner join titles as T on TA.title_id=T.title_id
where A.[state]='CA'
go

--3. N�mero de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
select count(title_id) as [Cantidad de libros],au_id from titleauthor
group by au_id
--having count(title_id)>=0
go

--4. N�mero de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.

--5. N�mero de empleados de cada editorial.
select P.pub_id,P.pub_name,count(E.emp_id) as [Numero de empleados] from publishers as P
inner join employee as E on P.pub_id=E.pub_id
group by P.pub_id, P.pub_name
order by P.pub_id
go

--6. Calcular la relaci�n entre n�mero de ejemplares publicados y n�mero de empleados de cada editorial, 
--incluyendo el nombre de la misma.

--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley� 
--o "Five Lakes Publishing�

--8. Empleados que hayan trabajado en alguna editorial que haya publicado alg�n libro en el que alguno de 
--los autores fuera Marjorie Green o Michael O'Leary.

--9. N�mero de ejemplares vendidos de cada libro, especificando el t�tulo y el tipo.

--10.  N�mero de ejemplares de todos sus libros que ha vendido cada autor.

--11.  N�mero de empleados de cada categor�a (jobs).

--12.  N�mero de empleados de cada categor�a (jobs) que tiene cada editorial, incluyendo aquellas categor�as 
--en las que no haya ning�n empleado.

--13.  Autores que han escrito libros de dos o m�s tipos diferentes

--14.  Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes 
--contenga la palabra "and�