
use TMPrueba
go


select M.Harina,M.TipoBase,sum(P.Importe) as [Total de ventas] from  TMPedidos as P
inner join TMMostachones as M on P.ID=M.IDPedido
where year(P.Enviado)=2015
group by M.Harina,M.TipoBase
go

--1. Mejor cliente (el que más nos compra) de cada ciudad.

select C.ID,C.Nombre,C.Apellidos,C.Ciudad,[Compras del Mejor Cliente] from TMClientes as C
inner join TMPedidos as P on C.ID=P.IDCliente
inner join 
	(select [Veces comprados].Ciudad,max([Veces comprados].[Cantidad de compras]) as [Compras del Mejor Cliente] from TMClientes as C
	inner join TMPedidos as P on C.ID=P.IDCliente
	inner join 
		(select C.ID,C.Nombre,C.Apellidos,C.Ciudad,count(*) as [Cantidad de compras] from TMClientes as C   --todos los pedidos de los clientes
		inner join TMPedidos as P on C.ID=P.IDCliente				
		group by C.ID,C.Nombre,C.Apellidos,C.Ciudad) as [Veces comprados] on C.Ciudad=[Veces comprados].Ciudad
	group by [Veces comprados].Ciudad) as [Mejor Cliente] on C.Ciudad=[Mejor Cliente].Ciudad
group by C.ID,C.Nombre,C.Apellidos,C.Ciudad,[Compras del Mejor Cliente]
having count(C.ID)=[Mejor Cliente].[Compras del Mejor Cliente]
go

--2. Añadir un nuevo complemento para el pedido 1
select * from TMPedidos
select * from TMComplementos
--como es una relacion N:M hay que incertar el compleneto en la tabla de complementos y en la tabla intermedia

insert into TMComplementos
			(ID,Complemento,Importe)
	values	(21,'Coñac armenio',40)

go

insert into TMPedidosComplementos
		(IDPedido,IDComplemento,Cantidad)
	values(1,21,1)
	
go
--3. El repartidor que mas pedidos ha repartido en cada ciudad
create view TodosLosRepartidores as
select E.Ciudad,R.ID,R.Nombre,R.Apellidos, count(*) as [Cantidad de repartos por repartidor] from TMRepartidores as R
inner join TMPedidos as P on R.ID=P.IDRepartidor
inner join TMEstablecimientos as E on P.IDEstablecimiento=E.ID
group by E.Ciudad,R.ID,R.Nombre,R.Apellidos

go
select R.ID,R.Nombre,R.Apellidos,MaximoReparto.[El mejor repartidor por ciudad] as [Top repartidor] from TodosLosRepartidores as R 
inner join TMPedidos as P on R.ID=P.IDRepartidor
inner join
	(
	select Ciudad,max([Cantidad de repartos por repartidor]) as [El mejor repartidor por ciudad] from TodosLosRepartidores as TLR
	group by Ciudad) as MaximoReparto 
	on R.Ciudad=MaximoReparto.Ciudad  and [El mejor repartidor por ciudad]=R.[Cantidad de repartos por repartidor]
group by R.ID,R.Nombre,R.Apellidos,MaximoReparto .[El mejor repartidor por ciudad]
go


--4. Indica el numero de pedidos que reparte cada repartidor al dia.

select R.Nombre,R.Apellidos,day(P.Enviado) as [Dia],count(*) as [Repartos] from  TMRepartidores as R
inner join TMPedidos as P on R.ID=P.IDRepartidor
group by  R.Nombre,R.Apellidos,day(P.Enviado)

--5. actualiza la tabla TMPedidos, para que el importe minimo sea 10

begin transaction

update TMPedidos
set Importe=10

--commit
rollback
select importe from TMPedidos
go
--6. Mes de mayor recaudacion de cada establecimiento durante el año 2015 y cantidad del mismo

--vamos a crear una vista para calcular el importe total mensual
create view [Importe Mensual] as
select E.ID,E.Denominacion,month(P.Enviado) as [Mes],sum(P.Importe) as [Total mensual] from TMEstablecimientos as E
inner join TMPedidos as P on E.ID=P.IDEstablecimiento
where year(P.Enviado)=2015
group by E.ID,E.Denominacion,month(P.Enviado)
go

select IM.ID,IM.Denominacion,month(P.Enviado) as [Mes],[Maxima recaudacion].[Ventas maximas por mes] as [Mes de mayor recaudacion] from [Importe Mensual] as IM
inner join TMPedidos as p on IM.ID=P.IDEstablecimiento
inner join
	(select IM.Denominacion,max([Total mensual]) as [Ventas maximas por mes] from [Importe Mensual] as IM
	group by IM.Denominacion) as [Maxima recaudacion] on IM.Denominacion=[Maxima recaudacion].Denominacion
group by  IM.ID,IM.Denominacion,month(P.Enviado),[Maxima recaudacion].[Ventas maximas por mes]

/***************copiado******************************/
select ImportePorMes.Denominacion, ImportePorMes.ImporteTotalMensual, ImportePorMes.Mes from (
	select ImportePorMes.Denominacion, max(ImportePorMes.ImporteTotalMensual) as ImporteMaximoAnual from (
		select E.Denominacion, month(P.Enviado) as Mes, sum(P.Importe) as ImporteTotalMensual from TMEstablecimientos as E
		inner join TMPedidos as P on E.ID = P.IDEstablecimiento
		where year(P.Enviado) = 2015
		group by E.Denominacion, month(P.Enviado)
		) as ImportePorMes
	group by ImportePorMes.Denominacion
	) as ImporteMaximo
inner join (
	select E.Denominacion, month(P.Enviado) as Mes, sum(P.Importe) as ImporteTotalMensual from TMEstablecimientos as E
	inner join TMPedidos as P on E.ID = P.IDEstablecimiento
	where year(P.Enviado) = 2015
	group by E.Denominacion, month(P.Enviado)
	) as ImportePorMes on ImporteMaximo.Denominacion = ImportePorMes.Denominacion 
	and ImporteMaximo.ImporteMaximoAnual = ImportePorMes.ImporteTotalMensual

--7. Numero de mostachones de cada tipo que ha comprado el cliente Armando Bronca Segura*/

select M.Harina, count(M.Harina) as CantidadComprada from TMClientes as C
inner join TMPedidos as P on C.ID = P.IDCliente
inner join TMMostachones as M on P.ID = M.IDPedido
where C.Nombre = 'Armando' and C.Apellidos = 'Bronca Segura'
group by M.Harina
