use ChiringLeo
go

select * from CLAlergenos
select * from CLCamarers
select * from CLCartaPlatos
select * from CLCartaVinos
select * from CLClientes
select * from CLComplementos
select * from CLEstablecimientos
select * from CLPedidos
select * from CLPedidosComplementos
select * from CLPedidosPlatos
select * from CLPedidosVinos
select * from CLPlatos
select * from CLPLatosAlergenos
select * from CLPLatosSecciones
select * from CLSecciones
select * from CLTiposVino
select * from CLVinos

go


create table ##PedidosCancelados --tablas temporales
(
	IDPedido bigint not null
)
go

declare @PedidoCancelado table
(
	IDPedido bigint not null	
)
go
declare @@VariableTipoTablla table(columna1 int,columna2 int)

select * from @@VariableTipoTablla

go

---------------------------------------------------------------------------------------------------------------
--prototipo: create function CLPedidosCamarers (@FechaIni as date, @FechaFin as date )
--comentarios: es una funcion inline que sirve para devolver el número de pedidos hechos a un camarer entre dos fechas.
--precondiciones: las fechas tiene que ser correctas
--entradas: dos fechas
--salidas: un numero
--entr/sal: no hay
--postcondiciones: se devolverá el ID de camarers, nombre, apellidos, telefono y número de pedidos atendidos.
---------------------------------------------------------------------------------------------------------------
create function CLPedidosCamarers (@FechaIni as date, @FechaFin as date )
	returns table as 
		return
			(
				select C.ID,C.Nombre,C.Apellidos,C.Telefono,count(*) as [Numero de pedidos] from CLCamarers as C
				inner join CLPedidos as P on C.ID=P.IDCamarer
				where P.Fecha between @FechaIni and @FechaFin
				group by C.ID,C.Nombre,C.Apellidos,C.Telefono
			)
go

declare @FechaInicial as date
declare @FechaFinal as date

set @FechaInicial='20150101'
set @FechaFinal ='20190430'

select * from CLPedidosCamarers (@FechaInicial,@FechaFinal)

go

--las veces que un cliente visita cada establecimiento

create function CLVecesVisitadosEstablecimiento (@IDCliente as int,@IDEstablecimiento as smallint)
	returns table as
		return
		(
			select C.ID,C.Nombre,C.Apellidos,count(P.IDEstablecimiento) as [Veces visitados] from CLClientes as C
			inner join CLPedidos as P on C.ID=P.IDCliente
			where C.ID=@IDCliente and P.IDEstablecimiento=@IDEstablecimiento
			group by C.ID,C.Nombre,C.Apellidos
		)
go

declare @IDCliente as int
declare @IDEstablecimiento as smallint

set @IDCliente=1
set @IDEstablecimiento =1

select * from CLVecesVisitadosEstablecimiento (@IDCliente,@IDEstablecimiento)


go

--un procedimiento que incerta un camarer y le asigna un pedido

alter procedure DarDeAltaCamarero

	@ID as smallint,
	@Nombre as varchar (20),
	@Apellidos as varchar (30),
	@Telefono as char (9),
	@IDEstablecimiento smallint

as

begin
	begin transaction
		declare @Codigo as int 
		declare @CodigoPedido as bigint
		select @Codigo = max(ID) +1  from CLCamarers
		select @CodigoPedido=max(ID)+1 from CLPedidos	--calcula el ultimo id y le suma 1

		insert into CLCamarers (ID,Nombre,Apellidos,Telefono,IDEstablecimiento)
		values(@Codigo,@Nombre,@Apellidos,@Telefono,@IDEstablecimiento)

		insert into CLPedidos(ID,Fecha,IDCliente,IDEstablecimiento,IDCamarer,Importe)
		values(1,'20180504',1,@IDEstablecimiento,@Codigo,10.20)--en el id pongo 1 porque no hay ninguno sino habia que poner @CodigoPedidos
	commit
end

go

begin transaction
execute DarDeAltaCamarero @ID = 45,
						  @Nombre = 'Nzhdeh',
						  @Apellidos = 'Yeghiazaryan',
						  @Telefono = '123456789',
						  @IDEstablecimiento = 1
rollback

--SET IDENTITY_INSERT CLPedidos ON  --para desactivar el identity temporalmente
--SET IDENTITY_INSERT CLPedidos OFF	--para volver a activarlo
--select isnull(cast(CC.Posicion as varchar(12)),'No terminado') as [Posiciones], count(CC.Posicion) as [NumVeces] from LTCaballosCarreras as CC


--create function [SinApuesta] (@IDCaballo as smallint, @IDCarrera as smallint)
--returns decimal (4,1) as
--	begin 
--		declare @Premio as decimal (4,1)
--		if(dbo.FnTotalApostadoCC(@IDCaballo, @IDCarrera)=0)
--			begin 
--				set @Premio=100
--			end
--		return @Premio
--	end
--go



/***********************************************************************************************************************/
--create procedure InscribirCaballo
	
--		@IDCaballo as smallint,
--		@IDCarrera as smallint,
--		@NumeroAsignado as tinyint output
--as

--begin 

--	declare @var as smallint
--	declare @inscrito as bit
--	declare @caballoExiste as bit

--	set @var=(select count(IDCaballo) from LTCaballosCarreras
--						where @IDCarrera=IDCarrera)

--	if exists (select * from LTCaballosCarreras
--				where @IDCarrera=IDCarrera and @IDCaballo=IDCaballo)
--	begin 
--		set @inscrito = 1
--	end

--	else
--	begin 
--		set @inscrito = 0
--	end
	
--	if exists (select * from LTCaballosCarreras
--				where @IDCarrera=IDCarrera and @IDCaballo=IDCaballo
--				)
--	begin 
--		set @caballoExiste = 1
--	end

--	else
--	begin 
--		set @caballoExiste = 0
--	end

--	insert into LTCaballosCarreras(IDCaballo,IDCarrera,Numero,Posicion,Premio1,Premio2)
--	values(@IDCaballo,@IDCarrera,round(((99-1-1)*rand()+1),0),null,2.5,5)

--	select @NumeroAsignado=
		
--		(
--			case 
--				when CA.ID is null then null
--				when @var>=8  then null
--				when @inscrito=1 then null 
--				when @caballoExiste=1 then null
--				else @NumeroAsignado
--			end 
--		)

--	 from LTCaballos as C
--	inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
--	inner join LTCarreras as CA on CC.IDCarrera=CA.ID
--end

--go

--declare @IDCaballo as smallint =99
--declare @IDCarrera as smallint =2
--declare @NumeroAsignado as tinyint

--execute InscribirCaballo @IDCaballo,@IDCarrera,@NumeroAsignado output


--create function CapcularPrecioCartaVinos()
--	returns money as
--		begin
--			declare @Precio as money
--			select @Precio=(CV.PVP*PV.Cantidad) from CLCartaVinos as CV
--			inner join CLPedidosVinos as PV on CV.IDVino=PV.IDVino
--			return @Precio
--		end
--go

--create function CapcularPrecioCartaPlatosTapas()
--	returns money as
--		begin
--			declare @Precio as money
--			select @Precio=(CP.PVPTapa*Pp.CantidadTapas) from CLCartaPlatos as CP
--			inner join CLPedidosPlatos as PP on CP.IDPlato=PP.IDPlato
--			return @Precio
--		end
--go

--create function CapcularPrecioCartaPlatosMedia()
--	returns money as
--		begin
--			declare @Precio as money
--			select @Precio=(CP.PVPMedia*Pp.CantidadMedias) from CLCartaPlatos as CP
--			inner join CLPedidosPlatos as PP on CP.IDPlato=PP.IDPlato
--			return @Precio
--		end
--go

--create function CapcularPrecioCartaPlatosRacion()
--	returns money as
--		begin
--			declare @Precio as money
--			select @Precio=(CP.PVPRacion*Pp.CantidadRaciones) from CLCartaPlatos as CP
--			inner join CLPedidosPlatos as PP on CP.IDPlato=PP.IDPlato
--			return @Precio
--		end
--go


--create function CapcularPrecioComplementos()
--	returns money as
--		begin
--			declare @Precio as money
--			select @Precio=(C.Importe*PC.Cantidad) from CLComplementos as C
--			inner join CLPedidosComplementos as PC on C.ID=PC.IDComplemento
--			return @Precio
--		end
--go