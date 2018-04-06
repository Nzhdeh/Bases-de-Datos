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

alter function FnPremioConseguido (@IDApuesta as int)
	returns money as
		begin 
			declare @Moneda as money
			
			select A.ID,@Moneda	from LTApuestas as A
				inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo
				--inner join
				--(
				--set CC.Posicion=
				--	case 
				--		when 1 then @Moneda=A.Importe*CC.Premio1
				--		when 2 then @Moneda=A.Importe*CC.Premio2
				--		when is null then @Moneda=A.Importe*CC.Premio1
				--		else 'No premiado'
				--	end
				--)
				where @IDApuesta=A.ID
			return @Moneda
		end
go

declare @IDApuesta as int

set @IDApuesta=1

select dbo.FnPremioConseguido (@IDApuesta)
go
		
--4.El procedimiento para calcular los premios en las apuestas de una carrera (los valores que deben 
--figurar en la columna Premio1 y Premio2) es el siguiente:

--	a.Se calcula el total de dinero apostado en esa carrera

--	b.El valor de la columna Premio1 para cada caballo se calcula 
--	dividiendo el total de dinero apostado entre lo apostado a ese 
--	caballo y se multiplica el resultado por 0.6

--	c.El valor de la columna Premio2 para cada caballo se calcula dividiendo 
--	el total de dinero apostado entre lo apostado a ese caballo y se multiplica el resultado por 0.2

--	d.Si a algún caballo no ha apostado nadie tanto el Premio1 como el Premio2 se ponen a 100.

--Crea una función que devuelva una tabla con tres columnas: ID de la apuesta, Premio1 y Premio2.

--Debes usar la función del Ejercicio 2. Si lo estimas oportuno puedes crear otras funciones para realizar parte de los cálculos.

--5.Crea una función FnPalmares que reciba un ID de caballo y un rango de fechas y nos devuelva 
--el palmarés de ese caballo en ese intervalo de tiempo. El palmarés es el número de victorias, 
--segundos puestos, etc. Se devolverá una tabla con dos columnas: Posición y NumVeces, que indicarán, 
--respectivamente, cada una de las posiciones y las veces que el caballo ha obtenido ese resultado. 
--Queremos que aparezcan 8 filas con las posiciones de la 1 a la 8. Si el caballo nunca ha finalizado 
--en alguna de esas posiciones, aparecerá el valor 0 en la columna NumVeces.

--6.Crea una función FnCarrerasHipodromo que nos devuelva las carreras celebradas en un hipódromo en un rango de fechas.
--La función recibirá como parámetros el nombre del hipódromo y la fecha de inicio y fin del intervalo 
--y nos devolverá una tabla con las siguientes columnas: Fecha de la carrera, número de orden, 
--numero de apuestas realizadas, número de caballos inscritos, número de caballos que la finalizaron y nombre del ganador.

--7.Crea una función FnObtenerSaldo a la que pasemos el ID de un jugador y una fecha y nos devuelva su saldo en esa fecha. 
--Si se omite la fecha, se devolverá el saldo actual