use ChiringLeo
go

/*
prototipo:
comentarios:
precondiciones:
entradas:
salidas:
postcondiciones:
*/

---------------------------------------------------------------------------------------------------------------
--prototipo: create function FnCarrerasCaballo (@FechaIni as date, @FechaFin as date )
--comentarios: es una funcion inline que sirve para devolver el número de carreras disputadas por cada caballo entre dos fechas.
--precondiciones: las fechas tiene que ser correctas
--entradas: dos fechas
--salidas: un numero
--entr/sal: no hay
--postcondiciones: se devolverá el ID (del caballo), nombre, sexo, fecha de nacimiento y número de carreras disputadas.
---------------------------------------------------------------------------------------------------------------

/*
Ejercicio 1
Por un error (alguien se olvidó de poner el WHERE), la columna Importe de la tabla CLPedidos ha quedado a NULL.
Queremos un procedimiento almacenado AsignarImportes que coloque los valores correctos.

Los precios de los complementos están en la tabla CLComplementos y son los mismos para todos los chiringuitos
Los de los vinos están en la tabla CLCartaVinos y pueden variar de un chiringuito a otro.
Los de los platos están en la tabla CLCartaPlatos y pueden variar de un chiringuito a otro.

PISTA: Se puede modular. Hacer funciones que calculen cosas (funciones catalanas, que diría M. Rajoy) 
para un pedido y usarlas en un UPDATE brutal. O también se puede hacer complicado si os gusta vivir al límite.

*/

select * from CLPedidos
select * from CLComplementos
select * from CLCartaVinos
select * from CLCartaPlatos

go

create function PrecioDeComplemento(@IDPedido as int)
returns money as
	begin
		declare @PrecioComplemento as money

		select @PrecioComplemento=(isnull((C.Importe),0) * isnull(CP.Cantidad,0)) from CLComplementos as C
		inner join CLPedidosComplementos as CP on C.ID=CP.IDComplemento
		where @IDPedido=CP.IDPedido

		return @PrecioComplemento
	end
go
select dbo.PrecioDeComplemento(1)

go
create function PrecioDeVino (@IDPedido as int)
returns money as
	begin
		declare @PrecioVino as money

		select @PrecioVino=( isnull(V.PVP,0) * isnull(PV.Cantidad,0)) from CLVinos as V
		inner join CLPedidosVinos as PV on V.ID=PV.IDVino
		where @IDPedido=PV.IDPedido

		return @PrecioVino
	end
go
select  dbo.PrecioDeVino(1)


go
create function PrecioDePlato(@IDPedido as int)
returns money as
	begin
		declare @PrecioPlatos as money
		select @PrecioPlatos=(
			   (isnull(P.PVPMediaRecomendado,0) * isnull(PP.CantidadMedias,0))+
			   (isnull(P.PVPRacionRecomendado,0) * isnull(PP.CantidadRaciones,0))+
			   (isnull(P.PVPTapaRecomendado,0) * isnull(PP.CantidadTapas,0)))
		from CLPlatos as P
		inner join CLPedidosPlatos as PP on P.ID=PP.IDPlato
		where @IDPedido=PP.IDPedido

		return @PrecioPlatos
	end
go

select dbo.PrecioDePlato(2)

go
create procedure AsignarImportes
as
begin 
	declare @Contador as int
	set @Contador=0

	while (select max(ID) from CLPedidos)>@Contador
	begin
		set @Contador=@Contador+1

		if exists (select ID from CLPedidos where @Contador=ID)
		begin 
			begin transaction CalcularPrecioPedidos
				update CLPedidos
				set Importe= sum(PrecioComplemento(@Contador)+PreciosDePlatos(@Contador)+PreciosDeVinos(@Contador))
				where @Contador=ID
			commit
		end
	end
end

/*
Ejercicio 3
Nos interesa conocer cuáles son los vinos preferidos de nuestros clientes según el tipo de plato. 
Queremos una función a la que se le pase el ID de un cliente y nos devuelva una tabla indicando 
cuál es el vino que prefiere cuando toma platos de cada sección. Las columnas de la tabla 
indicarán el ID y nombre de la sección, el nombre del vino que más veces ha acompañado con 
platos de esa sección y el número de veces que ha elegido ese vino.
*/

go
alter function ElVinoPotente (@IDCliente as int)
returns table as 
return
(
	select S.ID as IDSec,S.Nombre as NombreSec,V.ID,V.Nombre,OleVino.MejorVino from CLVinos as V
	inner join CLPedidosVinos as PV on V.ID=PV.IDVino
	inner join CLPedidos as P on PV.IDPedido=P.ID
	inner join CLPedidosPlatos as PP on P.ID=PP.IDPedido
	inner join CLPlatos as PL on PP.IDPlato=PL.ID
	inner join CLSecciones as S on PL.SeccionPrincipal=S.ID 
	inner join 
	(
		select S.ID as IDSec,S.Nombre as NombreSec,V.ID,V.Nombre,max(VinoMasVendido.VinoVendido) as MejorVino from CLVinos as V
		inner join CLPedidosVinos as PV on V.ID=PV.IDVino
		inner join CLPedidos as P on PV.IDPedido=P.ID
		inner join CLPedidosPlatos as PP on P.ID=PP.IDPedido
		inner join CLPlatos as PL on PP.IDPlato=PL.ID
		inner join CLSecciones as S on PL.SeccionPrincipal=S.ID 
		inner join 
				(
					select S.ID as IDSec,S.Nombre as NombreSec,V.ID,V.Nombre,sum(PV.Cantidad) as VinoVendido from CLVinos as V
					inner join CLPedidosVinos as PV on V.ID=PV.IDVino
					inner join CLPedidos as P on PV.IDPedido=P.ID
					inner join CLPedidosPlatos as PP on P.ID=PP.IDPedido
					inner join CLPlatos as PL on PP.IDPlato=PL.ID
					inner join CLSecciones as S on PL.SeccionPrincipal=S.ID 
					where P.IDCliente = @IDCliente
					group by S.ID,S.Nombre,V.ID,V.Nombre
				) as VinoMasVendido on S.ID=VinoMasVendido.ID and V.Nombre=VinoMasVendido.Nombre
			group by S.ID,S.Nombre,V.ID,V.Nombre,VinoMasVendido.VinoVendido
	) as OleVino on S.ID=OleVino.ID and V.Nombre=OleVino.Nombre
group by S.ID,S.Nombre,V.ID,V.Nombre,OleVino.MejorVino
--having sum(PV.Cantidad)=OleVino.MejorVino
)

go

declare @IDCliente as int

set @IDCliente=2

select * from ElVinoPotente(@IDCliente)
order by ID


























































