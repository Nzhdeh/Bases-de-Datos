use LeoMetro
go

--1. Crea una función inline que nos devuelva el número de estaciones que ha recorrido cada tren en un determinado periodo de tiempo. 
--El principio y el fin de ese periodo se pasarán como parámetros

--begin transaction
--rollback
go
create function [Estaciones Recorridas] (@FechaInicial as datetime, @FechaFinal as datetime)
	returns table as
		return 
		(
			select Tren,count(estacion) as [Estaciones] from LM_Recorridos
			where Momento between @FechaInicial and @FechaFinal
			group by Tren
		)
go

declare @FechaInicial as date
declare @FechaFinal as date

set @FechaInicial='20170225'
set @FechaFinal ='20170226'

select * from [Estaciones Recorridas] (@FechaInicial,@FechaFinal)


--2. Crea una función inline que nos devuelva el número de veces que cada usuario ha entrado en el metro en un periodo de tiempo.
-- El principio y el fin de ese periodo se pasarán como parámetros

--begin transaction

go
create function [Veces Entrado en el Metro] (@FechaInicial as datetime, @FechaFinal as datetime)
	returns table as
		return 
		(
			select IDPasajero,count (*) as [Veces Viajado] from LM_Viajes
			where MomentoEntrada between @FechaInicial and @FechaFinal
			group by IDPasajero
		)
go

declare @FechaInicial as date
declare @FechaFinal as date

set @FechaInicial='20170225'
set @FechaFinal ='20170226'

select * from [Veces Entrado en el Metro] (@FechaInicial,@FechaFinal)

--rollback

--3. Crea una función inline a la que pasemos la matrícula de un tren y una fecha de inicio y fin y nos devuelva una tabla con el 
--número de veces que ese tren ha estado en cada estación, además del ID, nombre y dirección de la estación
go
create function [Paso por Estacion] (@Matricula as char(7),@FechaInicial as datetime, @FechaFinal as datetime)
	returns table as
		return 
		(
			select E.ID,E.Direccion,E.Denominacion,count(*) as [Veces En Una Estacion] from LM_Trenes as T
			inner join LM_Recorridos as R on T.ID=R.Tren
			inner join LM_Estaciones as E on R.estacion=E.ID
			where T.Matricula=@Matricula and R.Momento between @FechaInicial and @FechaFinal
			group by E.ID,E.Direccion,E.Denominacion
		)
go

declare @FechaInicial as date
declare @FechaFinal as date
declare @Matricula as char(7)

set @FechaInicial='20170225'
set @FechaFinal ='20170226'
set @Matricula = '5607GLZ'

select * from [Paso por Estacion] (@Matricula,@FechaInicial,@FechaFinal)

--4. Crea una función inline que nos diga el número de personas que han pasado por una estacion en un periodo de tiempo. 
--Se considera que alguien ha pasado por una estación si ha entrado o salido del metro por ella. El principio y el fin 
--de ese periodo se pasarán como parámetros
go
alter function [Personas En La Estacion] (@FechaInicial as datetime, @FechaFinal as datetime)
	returns table as
		return 
		(
			select IDEstacionEntrada,IDEstacionSalida,count(*) as [Cantidad de pasajeros] from LM_Viajes
			where (MomentoEntrada between @FechaInicial and @FechaFinal) or (MomentoSalida between @FechaInicial and @FechaFinal)
			group by IDEstacionEntrada,IDEstacionSalida
		)
go

declare @FechaInicial as date
declare @FechaFinal as date

set @FechaInicial='20170225'
set @FechaFinal ='20170226'

select * from [Personas En La Estacion] (@FechaInicial,@FechaFinal)

--5. Crea una función inline que nos devuelva los kilómetros que ha recorrido cada tren en un periodo de tiempo. 
--El principio y el fin de ese periodo se pasarán como parámetros
go
create function [Kilometros Recorridos Por Tren] (@FechaInicial as datetime, @FechaFinal as datetime)
	returns table as
		return 
		(
			
		)
go

declare @FechaInicial as date
declare @FechaFinal as date

set @FechaInicial='20170225'
set @FechaFinal ='20170226'

select * from [Kilometros Recorridos Por Tren] (@FechaInicial,@FechaFinal)

--6. Crea una función inline que nos devuelva el número de trenes que ha circulado por cada línea en un periodo de tiempo. 
--El principio y el fin de ese periodo se pasarán como parámetros. Se devolverá el ID, denominación y color de la línea


--7. Crea una función inline que nos devuelva el tiempo total que cada usuario ha pasado en el metro en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros. Se devolverá ID, nombre y apellidos del pasajero.
--El tiempo se expresará en horas y minutos.