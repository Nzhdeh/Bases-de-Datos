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

declare @@VariableTipoTablla table(columna1 int,columna2 int)

select * from @@VariableTipoTablla