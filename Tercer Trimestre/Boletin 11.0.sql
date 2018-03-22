use LeoMetro
go

--1. Crea una funci�n inline que nos devuelva el n�mero de estaciones que ha recorrido cada tren en un determinado periodo de tiempo. 
--El principio y el fin de ese periodo se pasar�n como par�metros

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


--2. Crea una funci�n inline que nos devuelva el n�mero de veces que cada usuario ha entrado en el metro en un periodo de tiempo.
-- El principio y el fin de ese periodo se pasar�n como par�metros

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

--3. Crea una funci�n inline a la que pasemos la matr�cula de un tren y una fecha de inicio y fin y nos devuelva una tabla con el 
--n�mero de veces que ese tren ha estado en cada estaci�n, adem�s del ID, nombre y direcci�n de la estaci�n
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

--4. Crea una funci�n inline que nos diga el n�mero de personas que han pasado por una estacion en un periodo de tiempo. 
--Se considera que alguien ha pasado por una estaci�n si ha entrado o salido del metro por ella. El principio y el fin 
--de ese periodo se pasar�n como par�metros
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

--5. Crea una funci�n inline que nos devuelva los kil�metros que ha recorrido cada tren en un periodo de tiempo. 
--El principio y el fin de ese periodo se pasar�n como par�metros
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

--6. Crea una funci�n inline que nos devuelva el n�mero de trenes que ha circulado por cada l�nea en un periodo de tiempo. 
--El principio y el fin de ese periodo se pasar�n como par�metros. Se devolver� el ID, denominaci�n y color de la l�nea


--7. Crea una funci�n inline que nos devuelva el tiempo total que cada usuario ha pasado en el metro en un periodo de tiempo.
--El principio y el fin de ese periodo se pasar�n como par�metros. Se devolver� ID, nombre y apellidos del pasajero.
--El tiempo se expresar� en horas y minutos.