use ICOTR
go


--Escribe el código SQL necesario para realizar las siguientes operaciones sobre la base de datos ICOTR.

--Cuando la consulta sea muy compleja usa vistas para realizar partes de la misma

--Consultas con agregados

--1. Número de veces que se ha pedido cada topping
select IDTopping,count(*) as [Numero de veces Topping] from ICHeladosToppings
group by IDTopping

--2. Número de veces que se ha pedido cada topping cada año
select T.ID,count(*) as [Numero de veces Topping],year(P.Enviado) as [Año] from ICToppings as T
inner join ICHeladosToppings as HT on T.ID=HT.IDTopping
inner join ICHelados as H on HT.IDHelado=H.ID
inner join ICPedidos as P on H.IDPedido=P.ID
group by T.ID,year(P.Enviado)
order by T.ID


--3. Número de veces que se ha pedido cada topping en cada establecimiento
select T.ID,P.IDEstablecimiento,count(*) as [Numero de veces Topping] from ICToppings as T
inner join ICHeladosToppings as HT on T.ID=HT.IDTopping
inner join ICHelados as H on HT.IDHelado=H.ID
inner join ICPedidos as P on H.IDPedido=P.ID
--inner join ICEstablecimientos as E on P.IDEstablecimiento=E.ID
group by T.ID,P.IDEstablecimiento
order by T.ID

--4. Número de pedidos que incluyen cada topping. OJO: Un pedido puede incluir el mismo topping más de una vez

select distinct HT.IDTopping,count(*) as [Numero de pedidos] from ICPedidos as P
inner join ICHelados as H on P.ID=H.IDPedido
inner join ICHeladosToppings as HT on H.ID=HT.IDHelado
group by HT.IDTopping
order by HT.IDTopping


--5. Número de helados repartidos por cada repartidor en el año 2014.
select P.IDRepartidor,count(*) as [Numero de repartos por repartidor],year(P.Enviado) as [Año] from ICHelados as H
inner join ICPedidos as P on H.IDPedido=P.ID
group by P.IDRepartidor,year(P.Enviado)
order by P.IDRepartidor

--6. Número de pedidos y cantidad facturada por cada repartidor en el año 2014.
select IDRepartidor,count(*) [Numero de pedidos] , sum(Importe) as [Facturacion] from ICPedidos
group by IDRepartidor
order by IDRepartidor

--7. Pedidos (ID, Nombre y apellidos del cliente, nombre del establecimiento e importe) que incluyan el sabor menos 
--	vendido de cada ciudad. La ciudad se tomará del establecimiento.

create view CasoBaseSabor as --todos los pedidos con que incluyen los sabores
select P.ID,E.Ciudad,H.Sabor,count(*) as [Numero de sabores] from ICPedidos as P
inner join ICEstablecimientos as E on P.IDEstablecimiento=E.ID
inner join ICHelados as H on P.ID=H.IDPedido
group by P.ID,E.Ciudad,H.Sabor


select C.ID,C.Nombre,C.Apellidos,E.Denominacion,P.Importe from ICPedidos as P
inner join ICEstablecimientos as E on P.IDEstablecimiento=E.ID
inner join ICHelados as H on P.ID=H.IDPedido
inner join ICClientes as C on P.IDCliente=C.ID
inner  join
			(
				select Sabor,SaborMenosVendido from CasoBaseSabor as CBS
				inner join 
						(
							select ID,Ciudad,min([Numero de sabores]) as SaborMenosVendido from CasoBaseSabor -----------------Preguntar dudas
							group by ID,Ciudad
						)as Saborminimo on CBS.Ciudad=Saborminimo.Ciudad and CBS.[Numero de sabores]=SaborMenosVendido
			) as PeorSabor on H.Sabor=PeorSabor.Sabor
	group by P.ID,E.Ciudad,C.ID,C.Nombre,C.Apellidos,E.Denominacion,P.Importe,SaborMenosVendido
having count(P.ID)=PeorSabor.SaborMenosVendido


--8. Sabor más vendido en cada establecimiento. Incluir cuantos pedidos incluyen ese sabor. Ten en cuenta que en un 
--	pedido hay varios helados y varios pueden tener el mismo sabor.

alter view SaboresPorEstablecimiento as 
select E.ID,H.Sabor,count(*) as [Numero de sabores] from ICPedidos as P
inner join ICEstablecimientos as E on P.IDEstablecimiento=E.ID
inner join ICHelados as H on P.ID=H.IDPedido
group by E.ID,H.Sabor

select E.ID,P.ID,PedidosSabores,MasVendido from ICPedidos as P
inner join ICEstablecimientos as E on P.IDEstablecimiento=E.ID
inner join ICHelados as H on P.ID=H.IDPedido
inner join 
		(
			select P.ID,MasVendido,count (*) as [PedidosSabores] from ICPedidos as P
			inner join ICEstablecimientos as E on P.IDEstablecimiento=E.ID
			inner join ICHelados as H on P.ID=H.IDPedido
			inner join 
					(
						select ID,max([Numero de sabores]) as [MasVendido] from SaboresPorEstablecimiento
						group by ID
					) as SaborPorPedido on E.ID=SaborPorPedido.ID
				group by P.ID,MasVendido
		) as PedidosQueIncluyenSabores on P.ID=PedidosQueIncluyenSabores.ID
	group by P.ID,E.ID,PedidosSabores,MasVendido
--having count(P.ID)=PedidosQueIncluyenSabores.ID		dudas


--9. Cifra total de ventas de cada establecimiento en cada estación del año. El invierno va del 21 de diciembre al 21 de marzo, 
--	la primavera hasta en 21 de junio, el verano termina el 21 de septiembre.


--10. Porcentaje de helados que usan cada tipo de contenedor



--Otras cuestiones

--11. Añade a la tabla clientes una columna de tipo DECIMAL (3,2) llamada TipoDescuento. No admitirá valores nulos y 
--	  su valor por defecto es 0.00. El valor de esta columna indicará el tipo de descuento que hacemos a los clientes en sus pedidos en tanto por uno.
--12. Añade una restricción para que el valor de esa columna tenga que estar entre 0 y 0.3
--13. Rellena la columna sumando 0.02 a todos los clientes que hayan hecho más de tres pedidos durante los meses de octubre a febrero.