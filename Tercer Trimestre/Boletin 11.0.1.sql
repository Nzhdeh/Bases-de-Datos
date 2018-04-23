use LeoTurf
go

--Sobre la base de datos LeoTurf

--1.Crea una función inline llamada FnCarrerasCaballo que reciba un rango de fechas (inicio y fin) 
--y nos devuelva el número de carreras disputadas por cada caballo entre esas dos fechas. 
--Las columnas serán ID (del caballo), nombre, sexo, fecha de nacimiento y número de carreras disputadas.
---------------------------------------------------------------------------------------------------------------
--prototipo: create function FnCarrerasCaballo (@FechaIni as date, @FechaFin as date )
--comentarios: es una funcion inline que sirve para devolver el número de carreras disputadas por cada caballo entre dos fechas.
--precondiciones: las fechas tiene que ser correctas
--entradas: dos fechas
--salidas: un numero
--entr/sal: no hay
--postcondiciones: se devolverá el ID (del caballo), nombre, sexo, fecha de nacimiento y número de carreras disputadas.
---------------------------------------------------------------------------------------------------------------
create function FnCarrerasCaballo (@FechaIni as date, @FechaFin as date )
	returns table as 
		return

			(
				select C.ID,C.Nombre,C.Sexo,C.FechaNacimiento,count(*) as [Numero de carreras] from LTCaballos as C
				inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
				inner join LTCarreras as CR on CC.IDCarrera=CR.ID
				where CR.Fecha between @FechaIni and @FechaFin
				group by C.ID,C.Nombre,C.Sexo,C.FechaNacimiento
			)
go

declare @FechaInicial as date
declare @FechaFinal as date

set @FechaInicial='20180101'
set @FechaFinal ='20180430'

select * from FnCarrerasCaballo (@FechaInicial,@FechaFinal)
go
--2.Crea una función escalar llamada FnTotalApostadoCC que reciba como parámetros el ID de un 
--caballo y el ID de una carrera y nos devuelva el dinero que se ha apostado a ese caballo en esa carrera.
---------------------------------------------------------------------------------------------------------------
--prototipo: create function FnTotalApostadoCC (@IDCaballo as  smallint, @IDCarrera as  smallint)
--comentarios: es una funcion escalar que recibe como parámetros el ID de un caballo y el ID de una carrera
--			   y nos devolvuelve el dinero que se ha apostado a ese caballo en esa carrera.
--precondiciones: El id de caballo y el id de la carrera tienen que existir
--entradas: IDCaballo,IDCarrera
--salidas: un numero real
--entr/sal: no hay
--postcondiciones: se devolverá el dinero que se ha apostado a ese caballo en esa carrera.
---------------------------------------------------------------------------------------------------------------
create function FnTotalApostadoCC (@IDCaballo as  smallint, @IDCarrera as  smallint)
	returns money as
		begin 
			declare @Moneda as money

				select @Moneda=sum(Importe) from LTApuestas
				where @IDCaballo=IDCaballo and @IDCarrera=IDCarrera

			return @Moneda
		end
go

declare @IDCaballo as  smallint
declare @IDCarrera as  smallint

set @IDCaballo=20
set @IDCarrera=4

select dbo.FnTotalApostadoCC (@IDCaballo,@IDCarrera)
go
--3.Crea una función escalar llamada FnPremioConseguido que reciba como parámetros el ID de una apuesta 
--y nos devuelva el dinero que ha ganado dicha apuesta. Si todavía no se conocen las posiciones de los caballos, devolverá un NULL
---------------------------------------------------------------------------------------------------------------
--prototipo: create function FnPremioConseguido (@IDApuesta as int)
--comentarios: es una funcion escalar que recibe como parámetros el ID de una apuesta
--			   y nos devolvuelve el dinero que ha ganado dicha apuesta.
--precondiciones: el ID de una apuesta 
--entradas: IDApuesta
--salidas: un numero real
--entr/sal: no hay
--postcondiciones: se devolverá el dinero que se ha ganado por apuesta.
---------------------------------------------------------------------------------------------------------------
alter function FnPremioConseguido (@IDApuesta as int)
	returns money as
		begin 
			declare @Moneda as money
			
			select @Moneda=	
				(
					case 
						when CC.Posicion = 1 then A.Importe*CC.Premio1
						when CC.Posicion = 2 then A.Importe*CC.Premio2
						when CC.Posicion > 2 then 0
						else null 
					end
				)
				from LTApuestas as A
				inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
				where @IDApuesta=A.ID
			return @Moneda
		end
go

declare @IDApuesta as int

set @IDApuesta=5

select dbo.FnPremioConseguido (@IDApuesta)
go
		
--4.El procedimiento para calcular los premios en las apuestas de una carrera (los valores que deben 
--figurar en la columna Premio1 y Premio2) es el siguiente:

--	a.Se calcula el total de dinero apostado en esa carrera

--create view [Total dinero apostado] as

--select IDCarrera,sum(Importe) as [Dinero apostado] from LTApuestas
--group by IDCarrera

create function [TotalDineroApostado] (@IDCarrera as smallint)
returns money as
		begin 
			declare @DineroTotalPorApuesta as money
			
			select @DineroTotalPorApuesta=sum(Importe)

			from LTApuestas
			where @IDCarrera=IDCarrera

			return @DineroTotalPorApuesta
		end
go

declare @IDCarrera as smallint

set @IDCarrera=1

select dbo.FnPremioConseguido (@IDCarrera)
go
--	b.El valor de la columna Premio1 para cada caballo se calcula 
--	dividiendo el total de dinero apostado entre lo apostado a ese 
--	caballo y se multiplica el resultado por 0.6
create function [Calcular Premio1] (@IDCaballo as smallint, @IDCarrera as smallint)
returns decimal (4,1) as
	begin 
		declare @Premio as decimal (4,1)
		if(dbo.FnTotalApostadoCC(@IDCaballo, @IDCarrera)=0)
			begin 
				set @Premio=100
			end
		else
			begin
				select @Premio=(dbo.[TotalDineroApostado](@IDCarrera)/dbo.TotalApostadoCC(@IDCaballo, @IDCarrera))*0.6
				from LTApuestas as A
				inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
				where @IDCaballo=CC.IDCaballo and @IDCarrera=CC.IDCarrera
			end
		return @Premio
	end
go

declare @IDCaballo as  smallint
declare @IDCarrera as  smallint

set @IDCaballo=20
set @IDCarrera=4

select  dbo.[Calcular Premio1] (@IDCaballo,@IDCarrera)
go	
--	c.El valor de la columna Premio2 para cada caballo se calcula dividiendo 
--	el total de dinero apostado entre lo apostado a ese caballo y se multiplica el resultado por 0.2
 
create function [Calcular Premio2] (@IDCaballo as smallint, @IDCarrera as smallint)
returns decimal (4,1) as
	begin 
		declare @Premio as decimal (4,1)
		if(dbo.FnTotalApostadoCC(@IDCaballo, @IDCarrera)=0)
			begin 
				set @Premio=100
			end
		else
			begin
				select @Premio=(dbo.[TotalDineroApostado](@IDCarrera)/dbo.TotalApostadoCC(@IDCaballo, @IDCarrera))*0.2
				from LTApuestas as A
				inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
				where @IDCaballo=CC.IDCaballo and @IDCarrera=CC.IDCarrera
			end
		return @Premio
	end
go

declare @IDCaballo as  smallint
declare @IDCarrera as  smallint

set @IDCaballo=20
set @IDCarrera=4

select  dbo.[Calcular Premio2] (@IDCaballo,@IDCarrera)
go
--	d.Si a algún caballo no ha apostado nadie tanto el Premio1 como el Premio2 se ponen a 100.
create function [SinApuesta] (@IDCaballo as smallint, @IDCarrera as smallint)
returns decimal (4,1) as
	begin 
		declare @Premio as decimal (4,1)
		if(dbo.FnTotalApostadoCC(@IDCaballo, @IDCarrera)=0)
			begin 
				set @Premio=100
			end
		return @Premio
	end
go

declare @IDCaballo as  smallint
declare @IDCarrera as  smallint

set @IDCaballo=20
set @IDCarrera=4

select  dbo.[Calcular Premio2] (@IDCaballo,@IDCarrera)
go

--Crea una función que devuelva una tabla con tres columnas: ID de la apuesta, Premio1 y Premio2.

create function IDPremio1Premio2(@IDCaballo as smallint, @IDCarrera as smallint)
returns table as 
	return
		(
			select A.ID,dbo.[Calcular Premio1](@IDCaballo,@IDCarrera) as [Premio1],dbo.[Calcular Premio2](@IDCaballo,@IDCarrera) as [Premi2]
			from LTApuestas as A
			inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
			where @IDCaballo=CC.IDCaballo and @IDCarrera=CC.IDCarrera
		)
go

declare @IDCaballo as  smallint
declare @IDCarrera as  smallint

set @IDCaballo=20
set @IDCarrera=4

select * from dbo.IDPremio1Premio2 (@IDCaballo,@IDCarrera)
go

--Debes usar la función del Ejercicio 2. Si lo estimas oportuno puedes crear otras funciones para realizar parte de los cálculos.

--5.Crea una función FnPalmares que reciba un ID de caballo y un rango de fechas y nos devuelva 
--el palmarés de ese caballo en ese intervalo de tiempo. El palmarés es el número de victorias, 
--segundos puestos, etc. Se devolverá una tabla con dos columnas: Posición y NumVeces, que indicarán, 
--respectivamente, cada una de las posiciones y las veces que el caballo ha obtenido ese resultado. 
--Queremos que aparezcan 8 filas con las posiciones de la 1 a la 8. Si el caballo nunca ha finalizado 
--en alguna de esas posiciones, aparecerá el valor 0 en la columna NumVeces.

alter function FnPalmares (@IDCaballo as smallint, @FechaInicio as date, @FechaFin as date)
	returns table as
		return
			(
				select isnull(cast(CC.Posicion as varchar(20)),'No terminado') as [Posiciones], count(CC.Posicion) as [NumVeces] from LTCaballosCarreras as CC
				inner join LTCarreras as C on CC.IDCarrera=C.ID
				where CC.IDCaballo=@IDCaballo and C.Fecha between @FechaInicio and @FechaFin
				group by CC.Posicion
			)
go

declare @IDCaballo as  smallint
declare @FechaInicio as date
declare @FechaFin as date

set @IDCaballo=2
set @FechaInicio='20110228'
set @FechaFin='20180910'

select * from dbo.FnPalmares (@IDCaballo,@FechaInicio,@FechaFin)
go

select * from LTCaballosCarreras
where IDCaballo=2 


--6.Crea una función FnCarrerasHipodromo que nos devuelva las carreras celebradas en un hipódromo en un rango de fechas.
--La función recibirá como parámetros el nombre del hipódromo y la fecha de inicio y fin del intervalo 
--y nos devolverá una tabla con las siguientes columnas: Fecha de la carrera, número de orden, 
--numero de apuestas realizadas, número de caballos inscritos, número de caballos que la finalizaron y nombre del ganador.

--7.Crea una función FnObtenerSaldo a la que pasemos el ID de un jugador y una fecha y nos devuelva su saldo en esa fecha. 
--Si se omite la fecha, se devolverá el saldo actual