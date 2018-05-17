use LeoFest
go

--Especificaciones
--La Base de datos LeoFest recoge los datos sobre distintos festivales musicales que se celebran en España.

--Ejercicio 1
--Escribe un procedimiento almacenado que de de baja a una banda, actualizando su fecha de disolución y 
--la fecha de abandono de todos sus componentes actuales. La fecha de disolución y el ID de la banda se 
--pasarán como parámetros. Si no se especifica fecha, se tomará la actual.

--SET IDENTITY_INSERT LFBandas ON  --para desactivar el identity temporalmente
--SET IDENTITY_INSERT LFBandas OFF	--para volver a activarlo
create procedure darDeBajaBanda

		@FechaDicsolicion as date = null,
		@IDBanda as int
as
begin 
	begin transaction
		if(@FechaDicsolicion is null)
			begin
				update LFBandas
				set FechaDisolucion= cast(current_timestamp as date)
				where Id=@IDBanda 

				update LFMusicosBandas
				set FechaAbandono= cast(current_timestamp as date)
				where IDBanda=@IDBanda 
			end
		else
			begin
				update LFBandas
				set FechaDisolucion= @FechaDicsolicion
				where Id=@IDBanda 

				update LFMusicosBandas
				set FechaAbandono= @FechaDicsolicion
				where IDBanda=@IDBanda
			end
		commit
end

go
set dateformat ymd

begin transaction
--declare @IDBanda as int =1
--declare @FechaDisolucion as date ='20140930'
--con fecha
--execute darDeBajaBanda 1,'2016-05-04'
--sin fecha
execute darDeBajaBanda 1
rollback
go
select * from LFBandas
--Ejercicio 2
--Escribe una función que reciba como parámetro un año y nos devuelva una tabla indicando cuantas canciones 
--(temas) de cada estilo se han cantado en los distintos festivales celebrados a lo largo de ese año, el mismo 
--dato para el año inmediatamente anterior y una cuarta columna en la que aparezca un símbolo "+” si ha 
--aumentado el número de canciones de ese estilo respecto al año anterior, un "-” si ha disminuido y un "=” si no varía.
--El resultado tendrá cuatro columnas: Estilo, número de interpretaciones de ese estilo en el año anterior, 
--número de interpretaciones de ese estilo en el año que nos piden y símbolo que indique aumento o disminución.
--Puedes hacer otras funciones auxiliares a las que llames, pero no declarar vistas.
go
create function TemasCantados (@Año as int)
	returns table as
		return
		(
			select distinct T.IDEstilo,TemasAñoAnterior.[Temas cantados] as [Temas Cantados Año Anterior],count(*) as [Temas cantados], 
				case 
					when count(*) - [Temas cantados]>0 then '+'
					when count(T.ID) - [Temas cantados] = 0 then '='--UNA COLUMNA MAS
					when count(T.ID) - [Temas cantados] < 0 then '-'
				end as [Simbolos]
			
			from LFTemas as T
			inner join LFTemasBandasEdiciones as TBE on T.ID=TBE.IDTema
			inner join LFEdiciones as E on TBE.IDFestival =E.IDFestival and TBE.Ordinal=E.Ordinal 
			inner join LFEstilos as ES on T.IDEstilo=ES.ID
			inner join
					(
						select ES.Estilo,count(*) as [Temas cantados] from LFTemas as T
						inner join LFTemasBandasEdiciones as TBE on T.ID=TBE.IDTema
						inner join LFEdiciones as E on TBE.IDFestival =E.IDFestival and TBE.Ordinal=E.Ordinal
						inner join LFEstilos as ES on T.IDEstilo=ES.ID
						where (@Año-1) between year(E.FechaHoraInicio) and year(E.FechaHoraFin)
						group by ES.Estilo
					) as TemasAñoAnterior on TemasAñoAnterior.Estilo=ES.Estilo 
			where (@Año) between year(E.FechaHoraInicio) and year(E.FechaHoraFin)
			group by T.IDEstilo,TemasAñoAnterior.[Temas cantados]
		)
go
select * from TemasCantados (2007)

--Ejercicio 3
--Escribe un procedimiento TemaEjecutado y anote en la tabla LFBandasEdiciones que una banda ha interpretado 
--ese tema en una edición concreta de un festival.
--Los datos de entrada son: Titulo, IDAutor, Estilo (nombre del estilo), Duracion, El Id de un festival, 
--el ordinal de la edición, el ID de una banda y una fecha/hora.
--Si el tema es nuevo y no está dado de alta en la base de datos, se insertará en la tabla correspondiente. 
--Si el estilo no existe, también se dará de alta.

GO
CREATE PROCEDURE TemaEjecutado
	@Titulo VARCHAR(120)
	,@IDAutor INT
	,@Estilo VARCHAR(30)
	,@Duracion TIME(7)
	,@IDFestival INT
	,@Ordinal TINYINT
	,@IDBanda SMALLINT
AS
BEGIN
	--SI NO EXISTE EL ESTILO LO INSERTAMOS
	IF NOT EXISTS(SELECT Estilo FROM LFEstilos WHERE Estilo = @Estilo)
		BEGIN
			INSERT INTO LFEstilos (ID, Estilo)
			VALUES((SELECT MAX(ID) + 1 FROM LFEstilos), @Estilo)
		END
	
	--SI NO EXISTE EL TEMA LO INSERTAMOS
	IF NOT EXISTS(SELECT Titulo FROM LFTemas WHERE Titulo = @Titulo)
		BEGIN
			INSERT INTO LFTemas (ID, Titulo, IDAutor, IDEstilo, Duracion)
			VALUES(NEWID(), @Titulo, @IDAutor, (SELECT ID FROM LFEstilos WHERE Estilo = @Estilo), @Duracion)
		END

	INSERT INTO LFTemasBandasEdiciones (IDBanda, IDFestival, Ordinal, IDTema)
	VALUES (@IDBanda, @IDFestival, @Ordinal, (SELECT ID FROM LFTemas WHERE Titulo = @Titulo))
END
GO

BEGIN TRANSACTION
--un tema que no exista
EXECUTE TemaEjecutado 'Mi estrella Blanca', 1, 'Flamenco', '04:20', 5, 3, 1
--un estilo y un tema que no exista
EXECUTE TemaEjecutado 'Palabras de Papel', 1, 'TecnoFlamenco', '04:20', 5, 3, 1
--todo existe
EXECUTE TemaEjecutado 'Lagartija solidaria', 11, 'Hip-Hop', '02:40', 5, 3, 11
ROLLBACK TRANSACTION

--Ejercicio 4
--Escribe un procedimiento almacenado que actualice la columna caché de la tabla LFBandas de acuerdo a las siguientes reglas:
--•	Se computarán 105 € por cada miembro activo de la banda
--•	Se añadirán 170 € por cada actuación en los tres años anteriores
--•	Esa cantidad se incrementará un 5% si la banda toca alguno de los estilos Rock, Flamenco, Jazz o Blues y 
--	se decrementará un 50% si toca Reggaeton o Hip-Hop

--Nota: Valora la posibilidad de diseñar funciones para comprobar las condiciones.
