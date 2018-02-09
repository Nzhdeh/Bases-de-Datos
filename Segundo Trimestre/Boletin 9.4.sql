--Escribe las siguientes consultas sobre la base de datos Bichos.

use Bichos
go

--1.N�mero de mascotas que han sufrido cada enfermedad.
select E.ID,E.Nombre,count(*) [Numero de mascotas] from BI_Mascotas_Enfermedades as ME
inner join BI_Enfermedades as E on ME.IDEnfermedad=E.ID
group by E.ID,E.Nombre
go

--2.N�mero de mascotas que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota.
select E.ID,E.Nombre,count(ME.Mascota) [Numero de mascotas] from BI_Mascotas_Enfermedades as ME
right join BI_Enfermedades as E on ME.IDEnfermedad=E.ID
group by E.ID,E.Nombre
go
/*
select E.ID,E.Nombre,count(M.Codigo) [Numero de mascotas] from BI_Mascotas as M
inner join BI_Mascotas_Enfermedades as ME on M.Codigo=ME.Mascota
right join BI_Enfermedades as E on ME.IDEnfermedad=E.ID
group by E.ID,E.Nombre
go*/

--3.N�mero de mascotas de cada cliente. Incluye nombre completo y direcci�n del cliente.
select C.Nombre,C.Direccion,count (*) as [N�mero de mascotas de cada cliente] from BI_Clientes C
inner join BI_Mascotas as M on C.Codigo=M.CodigoPropietario
group by C.Nombre,C.Direccion
go 

--4.N�mero de mascotas de cada especie de cada cliente. Incluye nombre completo y direcci�n del cliente.
select C.Nombre,C.Direccion,M.Especie,count (*) as [N�mero de mascotas de cada cliente] from BI_Clientes C
inner join BI_Mascotas as M on C.Codigo=M.CodigoPropietario
group by C.Nombre,C.Direccion,M.Especie
go 

--5.N�mero de mascotas de cada especie que han sufrido cada enfermedad.
select M.Especie,ME.IDEnfermedad,count(*) as [N�mero de mascotas de cada especie] from BI_Mascotas as M
inner join BI_Mascotas_Enfermedades as ME on M.Codigo=ME.Mascota
group by M.Especie,ME.IDEnfermedad
go

--6.N�mero de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota de alguna especie.
select M.Especie,E.Nombre,count(M.Codigo) as [N�mero de mascotas de cada especie] from BI_Mascotas as M
inner join BI_Mascotas_Enfermedades as ME on M.Codigo=ME.Mascota
right join BI_Enfermedades as E on ME.IDEnfermedad=E.ID
group by M.Especie,E.Nombre
go

--7.Queremos saber cu�l es la enfermedad m�s com�n en cada especie. Incluye cuantos casos se han producido
create view Enfermedades as
select M.Especie,ME.IDEnfermedad,count(ME.IDEnfermedad) as [Cantidad de Enfermedades] from BI_Mascotas as M
inner join BI_Mascotas_Enfermedades as ME on M.Codigo=ME.Mascota
--inner join BI_Enfermedades as E on ME.IDEnfermedad=E.ID
group by M.Especie,ME.IDEnfermedad
go

--select E.Nombre,sum(ME.IDEnfermedad) as [Enfermedad mas comun] from BI_Enfermedades as E
--inner join BI_Mascotas_Enfermedades as ME on E.ID=ME.IDEnfermedad
--inner join BI_Mascotas as M on ME.Mascota=M.Codigo
--inner join 
--(
select MaxEnfermedadComunYEspecie.[Especie],MaxEnfermedadComunYEspecie.[Enfermedad mas comun] as [Top enfermedad],EN.Nombre  from Enfermedades as E
--inner join BI_Mascotas_Enfermedades as ME on E.IDEnfermedad=ME.IDEnfermedad
--inner join BI_Mascotas as M on ME.Mascota=M.Codigo
inner join

		(
		select Especie, max([Cantidad de Enfermedades]) [Enfermedad mas comun] from Enfermedades as ENF
		group by Especie) as MaxEnfermedadComunYEspecie 
		on E.Especie=MaxEnfermedadComunYEspecie.Especie AND [Enfermedad mas comun]=E.[Cantidad de Enfermedades]
	inner join BI_Enfermedades AS EN on E.IDEnfermedad = EN.ID


--		group by MaxEnfermedadComunYEspecie.[Especie]) as TopEnfermedad on TopEnfermedad.[Especie]=M.Especie
--group by E.Nombre,TopEnfermedad.[Top enfermedad] 
--having sum(ME.IDEnfermedad)=TopEnfermedad.[Top enfermedad] 
go
--8.Duraci�n media, en d�as, de cada enfermedad, desde que se detecta hasta que se cura. Incluye solo los casos en que el animal se haya curado. 
--Se entiende que una mascota se ha curado si tiene fecha de curaci�n y est� viva o su fecha de fallecimiento es posterior a la fecha de curaci�n.

--9.N�mero de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.

--10.N�mero de visitas a las que ha acudido cada mascota, fecha de su primera y de su �ltima visita

--11.Incremento (o disminuci�n) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas. Incluye nombre de la mascota, especie, 
--fecha de las dos consultas sucesivas e incremento o disminuci�n de peso.