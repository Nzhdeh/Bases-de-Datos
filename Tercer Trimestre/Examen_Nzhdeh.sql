use ChiringLeo
go
--La cadena de chiringuitos ChiringLeo se prepara para comenzar la temporada 2018, y nos ha pedido que desarrollemos 
--unos artefactos para su base de datos. Nos han facilitado la Base de datos de la temporada anterior (2017) para que hagamos pruebas.

--Ejercicio 1
--Por un error (alguien se olvid� de poner el WHERE), la columna Importe de la tabla CLPedidos ha quedado a NULL.

--Queremos un procedimiento almacenado AsignarImportes que coloque los valores correctos.

--Los precios de los complementos est�n en la tabla CLComplementos y son los mismos para todos los chiringuitos

--Los de los vinos est�n en la tabla CLCartaVinos y pueden variar de un chiringuito a otro.

--Los de los platos est�n en la tabla CLCartaPlatos y pueden variar de un chiringuito a otro.

--PISTA: Se puede modular. Hacer funciones que calculen cosas (funciones catalanas, que dir�a M. Rajoy) 
--para un pedido y usarlas en un UPDATE brutal. O tambi�n se puede hacer complicado si os gusta vivir al l�mite

/**he calculado los precios de CLCartaVinos y CLCartaPlatos,
porque ya lo habia hecho antes de que nos lo dijeras que se podia hace de otra forma**/

alter procedure ActualizarPrecios
		
			@IDPedido as bigint
as
	begin 
		declare @Precio as money
		begin transaction
			update CLPedidos
			set Importe=(select (((CP.PVPMedia*PP.CantidadMedias)+(CP.PVPRacion*PP.CantidadRaciones)+(CP.PVPTapa*PP.CantidadTapas))+(CV.PVP*PV.Cantidad)+(C.Importe*PC.Cantidad)) 
			from CLComplementos as C
			inner join CLPedidosComplementos as PC on C.ID=PC.IDComplemento
			inner join CLPedidos as P on PC.IDPedido=P.ID 
			inner join CLEstablecimientos as E on P.IDEstablecimiento=E.ID
			inner join CLCartaVinos as CV on E.ID=CV.IDEstablecimiento
			inner join CLCartaPlatos as CP on E.ID=CP.IDEstablecimiento
			inner join CLPedidosPlatos as PP on CP.IDPlato=PP.IDPlato
			inner join CLPedidosVinos as PV on CV.IDVino=PV.IDVino)
			--where
		commit
	end
 go

 begin transaction
 declare @IDPedido as bigint
 set @IDPedido=1

 execute ActualizarPrecios @IDPedido
 rollback




--Ejercicio 2
--Queremos hacer un ranking de los chiringuitos en base a una serie de par�metros. Para ello necesitamos una 
--funci�n que nos devuelva una tabla que contenga los siguientes datos: ID, nombre y ciudad del chiringuito, 
--n�mero de pedidos servidos en la temporada pasada, n�mero de platos servidos (contando tapas, medias y raciones), 
--facturaci�n, n�mero de botellas de vino vendidas y n�mero de clientes diferentes atendidos. La funci�n recibir�
-- como par�metros un intervalo de tiempo (inicio y fin del intervalo)
go
alter function RankingEctablecimiento (@FechaIni as date, @FechaFin as date )
	returns table as 
		return 
		(
			select E.ID,E.Denominacion,E.Ciudad, count(*) as [NumeroDePedidosServidos],count(distinct C.ID) as [NumeroClientesDistintos],
			(count(CP.PVPMedia)+count(CP.PVPTapa)+count(CP.PVPRacion)) as [NumeroPlatosServidos],
			count(CV.IDVino) as [BotellasVinoVendidos],sum(P.Importe) as[Facturacion] from CLEstablecimientos as E
			inner join CLPedidos as P on E.ID=P.IDEstablecimiento
			inner join CLClientes as C on P.IDCliente=C.ID
			inner join CLCartaVinos as CV on E.ID=CV.IDVino
			inner join CLCartaPlatos as CP on E.ID=CP.IDEstablecimiento
			where P.Fecha between @FechaIni and @FechaFin
			group by E.ID,E.Denominacion,E.Ciudad
		)
go
declare @FechaInicial as date
declare @FechaFinal as date

set @FechaInicial='20170101'
set @FechaFinal ='20180101'

select * from RankingEctablecimiento (@FechaInicial,@FechaFinal)

--Ejercicio 3
--Nos interesa conocer cu�les son los vinos preferidos de nuestros clientes seg�n el tipo de plato. Queremos una funci�n 
--a la que se le pase el ID de un cliente y nos devuelva una tabla indicando cu�l es el vino que prefiere cuando toma 
--platos de cada secci�n. Las columnas de la tabla indicar�n el ID y nombre de la secci�n, el nombre del vino que m�s 
--veces ha acompa�ado con platos de esa secci�n y el n�mero de veces que ha elegido ese vino.
go
alter view VinosVendidos as
select PV.IDVino,PV.IDPedido, count(*) as [Cantidad de vionos] from CLSecciones as s
inner join CLPlatos as P on S.ID=P.SeccionPrincipal
inner join CLPedidosPlatos as PP on P.ID=PP.IDPlato
inner join CLPedidos as PED on PP.IDPedido=PED.ID
inner join CLPedidosVinos as PV on PED.ID=PV.IDPedido 
inner join CLVinos as V on PV.IDVino=V.ID
group by PV.IDVino,PV.IDPedido

create view VinoMasVecesAcompa�ado as

select S.ID,VV.IDVino,MaxVino.[Vino mas vendido]  from VinosVendidos as VV
inner join
(
	select IDVino,Nombre as NombreVino,max([Cantidad de vionos]) as [Vino mas vendido] from VinosVendidos
	group by 
) as MaxVino  VV.IDVino=MaxVino.IDVino and [Vino mas vendido]=VV.[Cantidad de vionos]
inner join CLPlatos as P on S.ID=P.SeccionPrincipal
inner join CLPedidosPlatos as PP on P.ID=PP.IDPlato
inner join CLPedidos as PED on PP.IDPedido=PED.ID
inner join CLPedidosVinos as PV on PED.ID=PV.IDPedido 
inner join CLVinos as V on PV.IDVino=V.ID



go
create function VinosPreferidosClientes (@IDCliente as int)
	returns table as 
		return 
		(
			select S.ID,S.Nombre,VinoMasVecesAcompa�ado.NombreVino,sum(VinoMasVecesAcompa�ado.Cantidad) as NumeroVecesElegido 
			from CLSecciones as S
			inner join CLPlatos as P on S.ID=P.SeccionPrincipal
		)
go

declare @IDCliente as int
declare @FechaFinal as date

set @FechaInicial=1

select * from VinosPreferidosClientes (@IDCliente)