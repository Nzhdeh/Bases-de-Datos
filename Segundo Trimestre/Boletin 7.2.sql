use pubs
go

--Sobre la base de datos "pubs” (En la plataforma aparece como "Ejemplos 2000").

--1. Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
select title,price,notes from titles
where [type] !='trad_cook'
go

--2. ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
select job_id,job_desc,max_lvl,min_lvl from jobs
where 110 between min_lvl  and max_lvl
go

--3. Título, ID y tema de los libros que contengan la palabra "and” en las notas
select title,title_id,notes from titles
where notes like ('%and%')
go

--4. Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas
select pub_name,city from publishers
where country like ('USA') and [state] not in ('CA','TX')
go

--5. Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.
select title,price,title_id,[type] from titles
where ([type] ='psychology' or [type]= 'business') and (price between 10 and 20)
go

--6. Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.
select au_lname,au_fname,[address],city,[state] from authors
where [state] not in ('CA','OR')
go

--7. Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.
select au_lname,au_fname,[address],city,[state] from authors
where au_lname like '[DGS]%'
go

--8. ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente
select emp_id,fname,lname,job_lvl from employee
where job_lvl<100
order by lname,fname asc

--Modificaciones de datos

--1. Inserta un nuevo autor.
--select * from authors
insert into authors
(au_id,au_lname,au_fname,phone,[address],city,state,zip,[contract])
values ('172-44-1178','Yeghiazaryan','Nzhdeh','628-898-105','666 Calle Satanas','Sevilla','AN','12345',0)
go

--2. Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
--select * from titles
insert into titles
(title_id,title,[type],pub_id,price,advance,royalty,ytd_sales,notes,pubdate)
values('AM5555','Cataluña se va de vacaciones?','cachondeo',null,null,0,null,300,'Ooooo what a pity!','10-10-2017 00:00:00.000')
go

--3. Modifica la tabla jobs para que el nivel mínimo sea 90.

begin transaction
	update jobs
	set min_lvl=90
--commit
rollback
--select * from jobs
go
--4. Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.
select * from publishers
insert into publishers
(pub_id,pub_name,city,[state],country)
values ('9908','Mostachon Books','Utrera',null,null)
go

--5. Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart

--select * from publishers
begin transaction 
	update publishers
	set pub_name='Machen Wücher'
	where country='Germany'
--commit
rollback