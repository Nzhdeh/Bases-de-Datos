use TMPrueba
go

--1.
select E.Denominacion,E.Ciudad,month(P.Enviado) as [Mes],[Precio medio Mas caro].[Precio medio] as [Medio],[Precio medio Mas caro].[Precio maximo] as [Maximo] from TMPedidos as P
inner join TMEstablecimientos as E on P.IDEstablecimiento=E.ID
	inner join(
	select E.ID,E.Denominacion,E.Ciudad,month(P.Enviado) as [Mes],avg([Importe Pedidos].Precio) as [Precio medio],max([Importe Pedidos].Importe) [Precio maximo] from TMPedidos as P
	inner join TMEstablecimientos as E on P.IDEstablecimiento=E.ID
	inner join(
		select E.ID,E.Denominacion,E.Ciudad,month(P.Enviado) as [Mes],sum(P.Importe) as [Precio],P.Importe from TMPedidos as P
		inner join TMEstablecimientos as E on P.IDEstablecimiento=E.ID
		group by E.ID,E.Denominacion,E.Ciudad,month(P.Enviado),P.Importe) as [Importe Pedidos] on P.ID=[Importe Pedidos].ID
	group by E.ID,E.Denominacion,E.Ciudad,month(P.Enviado)) as [Precio medio Mas caro] on P.ID=[Precio medio Mas caro].ID
group by E.Denominacion,E.Ciudad,month(P.Enviado),[Precio medio Mas caro].[Precio medio],[Precio medio Mas caro].[Precio maximo]
having count(P.ID)=[Precio medio Mas caro].[Precio medio] and  count(P.ID)=[Precio medio Mas caro]. [Precio maximo]



--2. Queremos saber cual es el tipo de mostachon y el topping favorito de cada cliente. 
--Nombre y apellidos del cliente,ciudad, tipo de mostachon favorito y topping favorito

select C.ID,C.Nombre,C.Apellidos,C.Ciudad,M.Harina,[Mostachon Favorito],T.Topping from TMClientes as C
inner join TMPedidos as P on C.ID=P.IDCliente
inner join TMMostachones as M on P.ID=M.IDPedido
inner join TMMostachonesToppings as MT on M.ID=MT.IDMostachon
inner join TMToppings as T on MT.IDTopping=T.ID
inner join
	(select [Mostachon Topping].Nombre,[Mostachon Topping].Apellidos,max([Mostachon Topping].[Tipo de mostchon]) as [Mostachon Favorito],[Mostachon Topping].[Topping] as [Topping Favorito] from TMClientes as C
	inner join TMPedidos as P on C.ID=P.IDCliente
	inner join TMMostachones as M on P.ID=M.IDPedido
	inner join TMMostachonesToppings as MT on M.ID=MT.IDMostachon
	inner join
		(select C.ID,C.Nombre,C.Apellidos,C.Ciudad,M.Harina,count(*) as [Tipo de mostchon],T.Topping/*,count(T.ID) as [Toppings]*/ from TMClientes as C
		inner join TMPedidos as P on C.ID=P.IDCliente
		inner join TMMostachones as M on P.ID=M.IDPedido
		inner join TMMostachonesToppings as MT on M.ID=MT.IDMostachon
		inner join TMToppings as T on MT.IDTopping=T.ID
		group by C.ID,C.Nombre,C.Apellidos,C.Ciudad,M.Harina,T.Topping) as [Mostachon Topping] on C.Apellidos=[Mostachon Topping].Apellidos and C.Nombre=[Mostachon Topping].Nombre
	group by [Mostachon Topping].Nombre,[Mostachon Topping].Apellidos,[Mostachon Topping].[Topping]) as [Favoritos] on C.Apellidos=[Favoritos].Apellidos and C.Nombre=[Favoritos].Nombre
group by C.ID,C.Nombre,C.Apellidos,C.Ciudad,M.Harina,[Mostachon Favorito],T.Topping
having count(C.ID)=Favoritos.[Mostachon Favorito]
go


--3. Queremos saber los establecimientos que aumentan o disminuyen el numero de mostachones que venden,
--para ello queremos una consulta que nos diga el nombre y la ciudad del establesiminto,el numero de 
--mostachones vendidos en el año actual en el año anterior (si existe) y su aumento o disminucion en tanto por cinto

select E.ID,E.Denominacion,E.Ciudad,count(*) as [Numero de mostachones vendidos],P.Enviado from TMEstablecimientos as E
inner join TMPedidos as P on E.ID=P.IDEstablecimiento--sacamos el numero de todos los mostachones vendidos de todos los años
inner join TMPedidos as P2 on P.ID=P2.ID
inner join TMMostachones as M on P2.ID=M.IDPedido
where P.Enviado>P2.Enviado
group by E.ID,E.Denominacion,E.Ciudad,p.Enviado

--4.
select * from TMToppings
go
insert into TMToppings
		(ID,Topping) 
	values(9,'Wasabi')
go
insert into TMBases
		(Base)
		values('Bambú')

begin transaction 

	update TMPedidos
	set ID=(select P.IDEstablecimiento from TMPedidos as P			
				inner join TMMostachones as M on P.ID=M.IDPedido
				inner join TMBases as B on M.TipoBase=B.Base
				inner join TMMostachonesToppings as MT on M.ID=MT.IDMostachon
				inner join TMToppings as T on MT.IDTopping=T.ID
				where B.Base='Sirope' and T.Topping='Tradicional' and IDEstablecimiento=28)

	where ID=(select P.IDEstablecimiento from TMPedidos as P			--al menos no se me ha olvidad el where)))))))
				inner join TMMostachones as M on P.ID=M.IDPedido
				inner join TMBases as B on M.TipoBase=B.Base
				inner join TMMostachonesToppings as MT on M.ID=MT.IDMostachon
				inner join TMToppings as T on MT.IDTopping=T.ID
				where B.Base='Wasabi' and T.Topping='Bambú' and IDEstablecimiento=28)

--commit
rollback


--5.

insert into TMPedidos
		(ID,Recibido,Enviado,IDCliente,IDEstablecimiento,IDRepartidor,Importe)
	values(2501,current_timestamp,null,307,22,null,5.2)
go

insert into TMBases
	(Base)
	values('Papel reciclado')
go

insert into TMToppings
	(ID,Topping)
	values(100,'Mermelada')
go


insert into TMMostachones
		(ID,IDPedido,TipoBase,Harina)
	values(6500,2501,'Papel reciclado','Maíz')	
go

insert into TMMostachones
		(ID,IDPedido,TipoBase,Harina)
values(6501,2501,'Cartulina','Espelta')

insert into TMMostachonesToppings
		(IDMostachon,IDTopping) values(6500,100)
