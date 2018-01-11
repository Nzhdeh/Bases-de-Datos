--Sobre la base de datos BICHOS.
use Bichos
go
--Introduce dos nuevos clientes. Asígnales los códigos que te parezcan adecuados.
--select * from BI_Clientes
insert into BI_Clientes
		(Codigo,Telefono,Direccion,NumeroCuenta,Nombre)
values  (107,'789354568','En un lugar seguro',null,'Constantin Noseque')
go
insert into BI_Clientes
		(Codigo,Telefono,Direccion,NumeroCuenta,Nombre)
values  (108,'632584568','En las Himalayas','HI5523658525411447585223','No me llamo')
	   
--Introduce una mascota para cada uno de ellos. Asígnales los códigos que te parezcan adecuados.
select * from BI_Mascotas
insert into BI_Mascotas
		(Codigo,Raza,Especie,FechaNacimiento,FechaFallecimiento,Alias,CodigoPropietario)
values  ('MH001','Desconocida','Gato','2-11-2017',null,'Pichi',107)
go
insert into BI_Mascotas
		(Codigo,Raza,Especie,FechaNacimiento,FechaFallecimiento,Alias,CodigoPropietario)
values  ('MH002','Boxer','Perro','2-11-2000','2-2-2017','Niculin',108)
go
--Escribe un SELECT para obtener los IDs de las enfermedades que ha sufrido alguna mascota (una cualquiera). 
--Los IDs no deben repetirse
select distinct IDEnfermedad from BI_Mascotas_Enfermedades/************************************/
go
--El cliente Josema Ravilla ha llevado a visita a todas sus mascotas.
--Escribe un SELECT para averiguar el código de Josema Ravilla.
select Codigo from BI_Clientes
where Nombre='Josema Ravilla'
go
--Escribe otro SELECT para averiguar los códigos de las mascotas de Josema Ravilla.
select Codigo from BI_Mascotas
where CodigoPropietario=102
go
--Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Visitas. La fecha y hora se tomarán del sistema.
--select * from BI_Visitas
insert into BI_Visitas
		(Fecha,Temperatura,Peso,Mascota)
values  (CURRENT_TIMESTAMP,40,100,'GM002')
go
insert into BI_Visitas
		(Fecha,Temperatura,Peso,Mascota)
values  (CURRENT_TIMESTAMP,37,13,'PH002')
go
--Todos los perros del cliente 104 han enfermado el 20 de diciembre de sarna.
--Escribe un SELECT para averiguar los códigos de todos los perros del cliente 104
--select * from BI_Mascotas_Enfermedades
--select * from BI_Mascotas
select * from BI_Mascotas as M
inner join BI_Mascotas_Enfermedades as ME on M.Codigo=ME.Mascota


--Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Mascotas_Enfermedades

--Escribe una consulta para obtener el nombre, especie y raza de todas las mascotas, ordenados por edad.
select Alias,Especie,Raza from BI_Mascotas
order by FechaNacimiento
--Escribe los códigos de todas las mascotas que han ido alguna vez al veterinario un lunes o un viernes. Para averiguar el 
--dia de la semana de una fecha se usa la función DATEPART (WeekDay, fecha) que devuelve un entero entre 1 y 7 donde el 1 
--corresponde al lunes, el dos al martes y así sucesivamente.
--NOTA: El servidor se puede configurar para que la semana empiece en lunes o domingo.