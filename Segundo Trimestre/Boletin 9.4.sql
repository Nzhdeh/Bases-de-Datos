--Escribe las siguientes consultas sobre la base de datos Bichos.

use Bichos
go

--1.Número de mascotas que han sufrido cada enfermedad.
select E.ID,E.Nombre,count(*) [Numero de mascotas] from BI_Mascotas_Enfermedades as ME
inner join BI_Enfermedades as E on ME.IDEnfermedad=E.ID
group by E.ID,E.Nombre
go

--2.Número de mascotas que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota.
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

--3.Número de mascotas de cada cliente. Incluye nombre completo y dirección del cliente.
select C.Nombre,C.Direccion,count (*) as [Número de mascotas de cada cliente] from BI_Clientes C
inner join BI_Mascotas as M on C.Codigo=M.CodigoPropietario
group by C.Nombre,C.Direccion
go 

--4.Número de mascotas de cada especie de cada cliente. Incluye nombre completo y dirección del cliente.
select C.Nombre,C.Direccion,M.Especie,count (*) as [Número de mascotas de cada cliente] from BI_Clientes C
inner join BI_Mascotas as M on C.Codigo=M.CodigoPropietario
group by C.Nombre,C.Direccion,M.Especie
go 

--5.Número de mascotas de cada especie que han sufrido cada enfermedad.
select M.Especie,ME.IDEnfermedad,count(*) as [Número de mascotas de cada especie] from BI_Mascotas as M
inner join BI_Mascotas_Enfermedades as ME on M.Codigo=ME.Mascota
group by M.Especie,ME.IDEnfermedad
go

--6.Número de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota de alguna especie.
select M.Especie,E.Nombre,count(M.Codigo) as [Número de mascotas de cada especie] from BI_Mascotas as M
inner join BI_Mascotas_Enfermedades as ME on M.Codigo=ME.Mascota
right join BI_Enfermedades as E on ME.IDEnfermedad=E.ID
group by M.Especie,E.Nombre
go

--7.Queremos saber cuál es la enfermedad más común en cada especie. Incluye cuantos casos se han producido
create view Enfermedades as
select M.Especie,ME.IDEnfermedad,count(ME.IDEnfermedad) as [Cantidad de Enfermedades] from BI_Mascotas as M
inner join BI_Mascotas_Enfermedades as ME on M.Codigo=ME.Mascota
--inner join BI_Enfermedades as E on ME.IDEnfermedad=E.ID
group by M.Especie,ME.IDEnfermedad
go

select MaxEnfermedadComunYEspecie.[Especie],MaxEnfermedadComunYEspecie.[Enfermedad mas comun] as [Top enfermedad],EN.Nombre  from Enfermedades as E
inner join
		(
		select Especie, max([Cantidad de Enfermedades]) as [Enfermedad mas comun] from Enfermedades as ENF
		group by Especie) as MaxEnfermedadComunYEspecie on E.Especie=MaxEnfermedadComunYEspecie.Especie AND [Enfermedad mas comun]=E.[Cantidad de Enfermedades]
		inner join BI_Enfermedades AS EN on E.IDEnfermedad = EN.ID
go

--8.Duración media, en días, de cada enfermedad, desde que se detecta hasta que se cura. Incluye solo los casos en que el animal se haya curado. 
--Se entiende que una mascota se ha curado si tiene fecha de curación y está viva o su fecha de fallecimiento es posterior a la fecha de curación.
select M.Codigo,M.Alias,datediff(day,ME.FechaInicio,ME.FechaCura) as [Duracion en dias] from BI_Mascotas_Enfermedades as ME
inner join BI_Mascotas as m on ME.Mascota=M.Codigo
where ME.FechaCura is not null
go

--select * from BI_Mascotas_Enfermedades
--select * from BI_Mascotas
--9.Número de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.
select C.Nombre,M.Codigo,count(*) as [Numero de acudidos] from BI_Clientes as C 
inner join  BI_Mascotas as M on C.Codigo=M.CodigoPropietario
inner join BI_Visitas as V on M.Codigo=V.Mascota 
group by C.Nombre,M.Codigo
go

--10.Número de visitas a las que ha acudido cada mascota, fecha de su primera y de su última visita
select M.Alias,count(*) as [Numero de veces acudidos],ME.FechaInicio,ME.FechaCura from BI_Mascotas as M
inner join BI_Mascotas_Enfermedades as ME on M.Codigo =ME.Mascota
group by M.Alias,ME.FechaInicio,ME.FechaCura
go

--11.Incremento (o disminución) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas. 
--Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e incremento o disminución de peso.


(select distinct V.IDVisita,V.Mascota,V.Peso,V.Fecha from BI_Visitas as V
		inner join BI_Visitas as V2 on V.Mascota=V2.Mascota
		inner join (select V.IDVisita,V.Mascota,V.Peso,V.Fecha from BI_Visitas as V
					inner join BI_Visitas as V2 on V.Mascota=V2.Mascota
					where V.Fecha<V2.Fecha
					) as [Fecha primera visita] on V.Mascota=[Fecha primera visita].Mascota and V.Fecha>[Fecha primera visita].Fecha
		) as [Fecha de la visita proxima] on V.Mascota=[Fecha de la visita proxima].Mascota
	
