use LeoFest
go

--Especificaciones
--La Base de datos LeoFest recoge los datos sobre distintos festivales musicales que se celebran en Espa�a.

--Ejercicio 1
--Escribe un procedimiento almacenado que de de baja a una banda, actualizando su fecha de disoluci�n y 
--la fecha de abandono de todos sus componentes actuales. La fecha de disoluci�n y el ID de la banda se 
--pasar�n como par�metros. Si no se especifica fecha, se tomar� la actual.
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
go

--Ejercicio 2
--Escribe una funci�n que reciba como par�metro un a�o y nos devuelva una tabla indicando cuantas canciones 
--(temas) de cada estilo se han cantado en los distintos festivales celebrados a lo largo de ese a�o, el mismo 
--dato para el a�o inmediatamente anterior y una cuarta columna en la que aparezca un s�mbolo "+� si ha 
--aumentado el n�mero de canciones de ese estilo respecto al a�o anterior, un "-� si ha disminuido y un "=� si no var�a.
--El resultado tendr� cuatro columnas: Estilo, n�mero de interpretaciones de ese estilo en el a�o anterior, 
--n�mero de interpretaciones de ese estilo en el a�o que nos piden y s�mbolo que indique aumento o disminuci�n.
--Puedes hacer otras funciones auxiliares a las que llames, pero no declarar vistas.
create function TemasCantados (@A�o as int)
	returns table as
		return
		(
			select distinct T.IDEstilo,TemasA�oAnterior.[Temas cantados] as [Temas Cantados A�o Anterior],count(*) as [Temas cantados] 
				case 
					when count(*) - TemasA�oAnterior>0 then '+'
					when count(T.ID) - TemasA�oAnterior = 0 then '='
					when count(T.ID) - TemasA�oAnterior < 0 then '-'
				end
			
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
						where (@A�o-1) between year(E.FechaHoraInicio) and year(E.FechaHoraFin)
						group by ES.Estilo
					) as TemasA�oAnterior on TemasA�oAnterior.Estilo=ES.Estilo 
			where (@A�o) between year(E.FechaHoraInicio) and year(E.FechaHoraFin)
			group by T.IDEstilo,TemasA�oAnterior.[Temas cantados]
		)

--Ejercicio 3
--Escribe un procedimiento TemaEjecutado y anote en la tabla LFBandasEdiciones que una banda ha interpretado 
--ese tema en una edici�n concreta de un festival.
--Los datos de entrada son: Titulo, IDAutor, Estilo (nombre del estilo), Duracion, El Id de un festival, 
--el ordinal de la edici�n, el ID de una banda y una fecha/hora.
--Si el tema es nuevo y no est� dado de alta en la base de datos, se insertar� en la tabla correspondiente. 
--Si el estilo no existe, tambi�n se dar� de alta.

--Ejercicio 4
--Escribe un procedimiento almacenado que actualice la columna cach� de la tabla LFBandas de acuerdo a las siguientes reglas:
--�	Se computar�n 105 � por cada miembro activo de la banda
--�	Se a�adir�n 170 � por cada actuaci�n en los tres a�os anteriores
--�	Esa cantidad se incrementar� un 5% si la banda toca alguno de los estilos Rock, Flamenco, Jazz o Blues y 
--	se decrementar� un 50% si toca Reggaeton o Hip-Hop

--Nota: Valora la posibilidad de dise�ar funciones para comprobar las condiciones.
