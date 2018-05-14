use LeoFest
go

--Especificaciones
--La Base de datos LeoFest recoge los datos sobre distintos festivales musicales que se celebran en España.

--Ejercicio 1
--Escribe un procedimiento almacenado que de de baja a una banda, actualizando su fecha de disolución y 
--la fecha de abandono de todos sus componentes actuales. La fecha de disolución y el ID de la banda se 
--pasarán como parámetros. Si no se especifica fecha, se tomará la actual.
create procedure darDeBajaBanda

		@FechaDicsolicion as date = null,
		@IDBanda as smallint
as
begin 

	if(@FechaDicsolicion is null)
		begin
			update LFBandas
			set FechaDisolucion= current_timestamp
			where Id=@IDBanda 

			update LFMusicosBandas
			set FechaAbandono= current_timestamp
			where Id=@IDBanda 
		end
	else
		begin
			update LFBandas
			set FechaDisolucion= @FechaDicsolicion
			where Id=@IDBanda 

			update LFMusicosBandas
			set FechaAbandono= @FechaDicsolicion
			where Id=@IDBanda
		end
end

go

begin transaction
declare @IDBanda as smallint =99
declare @FechaDisolucion as date ='02022017'

execute darDeBajaBanda @IDBanda,@FechaDisolucion


--Ejercicio 2
--Escribe una función que reciba como parámetro un año y nos devuelva una tabla indicando cuantas canciones 
--(temas) de cada estilo se han cantado en los distintos festivales celebrados a lo largo de ese año, el mismo 
--dato para el año inmediatamente anterior y una cuarta columna en la que aparezca un símbolo "+” si ha 
--aumentado el número de canciones de ese estilo respecto al año anterior, un "-” si ha disminuido y un "=” si no varía.
--El resultado tendrá cuatro columnas: Estilo, número de interpretaciones de ese estilo en el año anterior, 
--número de interpretaciones de ese estilo en el año que nos piden y símbolo que indique aumento o disminución.
--Puedes hacer otras funciones auxiliares a las que llames, pero no declarar vistas.

--Ejercicio 3
--Escribe un procedimiento TemaEjecutado y anote en la tabla LFBandasEdiciones que una banda ha interpretado 
--ese tema en una edición concreta de un festival.
--Los datos de entrada son: Titulo, IDAutor, Estilo (nombre del estilo), Duracion, El Id de un festival, 
--el ordinal de la edición, el ID de una banda y una fecha/hora.
--Si el tema es nuevo y no está dado de alta en la base de datos, se insertará en la tabla correspondiente. 
--Si el estilo no existe, también se dará de alta.
--Ejercicio 4
--Escribe un procedimiento almacenado que actualice la columna caché de la tabla LFBandas de acuerdo a las siguientes reglas:
--•	Se computarán 105 € por cada miembro activo de la banda
--•	Se añadirán 170 € por cada actuación en los tres años anteriores
--•	Esa cantidad se incrementará un 5% si la banda toca alguno de los estilos Rock, Flamenco, Jazz o Blues y 
--	se decrementará un 50% si toca Reggaeton o Hip-Hop

--Nota: Valora la posibilidad de diseñar funciones para comprobar las condiciones.
