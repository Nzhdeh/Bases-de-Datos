use ChiringLeo
go
--La cadena de chiringuitos ChiringLeo se prepara para comenzar la temporada 2018, y nos ha pedido que desarrollemos 
--unos artefactos para su base de datos. Nos han facilitado la Base de datos de la temporada anterior (2017) para que hagamos pruebas.

--Ejercicio 1
--Por un error (alguien se olvidó de poner el WHERE), la columna Importe de la tabla CLPedidos ha quedado a NULL.

--Queremos un procedimiento almacenado AsignarImportes que coloque los valores correctos.

--Los precios de los complementos están en la tabla CLComplementos y son los mismos para todos los chiringuitos

--Los de los vinos están en la tabla CLCartaVinos y pueden variar de un chiringuito a otro.

--Los de los platos están en la tabla CLCartaPlatos y pueden variar de un chiringuito a otro.

--PISTA: Se puede modular. Hacer funciones que calculen cosas (funciones catalanas, que diría M. Rajoy) 
--para un pedido y usarlas en un UPDATE brutal. O también se puede hacer complicado si os gusta vivir al límite

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
--Queremos hacer un ranking de los chiringuitos en base a una serie de parámetros. Para ello necesitamos una 
--función que nos devuelva una tabla que contenga los siguientes datos: ID, nombre y ciudad del chiringuito, 
--número de pedidos servidos en la temporada pasada, número de platos servidos (contando tapas, medias y raciones), 
--facturación, número de botellas de vino vendidas y número de clientes diferentes atendidos. La función recibirá
-- como parámetros un intervalo de tiempo (inicio y fin del intervalo)
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
--Nos interesa conocer cuáles son los vinos preferidos de nuestros clientes según el tipo de plato. Queremos una función 
--a la que se le pase el ID de un cliente y nos devuelva una tabla indicando cuál es el vino que prefiere cuando toma 
--platos de cada sección. Las columnas de la tabla indicarán el ID y nombre de la sección, el nombre del vino que más 
--veces ha acompañado con platos de esa sección y el número de veces que ha elegido ese vino.
go
alter view VinosVendidos as
select PV.IDVino,PV.IDPedido, count(*) as [Cantidad de vionos] from CLSecciones as s
inner join CLPlatos as P on S.ID=P.SeccionPrincipal
inner join CLPedidosPlatos as PP on P.ID=PP.IDPlato
inner join CLPedidos as PED on PP.IDPedido=PED.ID
inner join CLPedidosVinos as PV on PED.ID=PV.IDPedido 
inner join CLVinos as V on PV.IDVino=V.ID
group by PV.IDVino,PV.IDPedido

create view VinoMasVecesAcompañado as

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
			select S.ID,S.Nombre,VinoMasVecesAcompañado.NombreVino,sum(VinoMasVecesAcompañado.Cantidad) as NumeroVecesElegido 
			from CLSecciones as S
			inner join CLPlatos as P on S.ID=P.SeccionPrincipal
		)
go

declare @IDCliente as int
declare @FechaFinal as date

set @FechaInicial=1

select * from VinosPreferidosClientes (@IDCliente)