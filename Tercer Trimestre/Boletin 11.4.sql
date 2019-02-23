use CentroDeportivo
go

--Sobre la base de datos CentroDeportivo.

--Ejercicio 1
--Escribe un procedimiento EliminarUsuario que reciba como parámetro el DNI de un usuario, 
--le coloque un NULL en la columna Sex y borre todas las reservas futuras de ese usuario. 
--Ten en cuenta que si alguna de esas reservas tiene asociado un alquiler de material habrá que borrarlo también.

alter procedure EliminarUsuario 

	@Dni as char(9)

as

begin 

	begin transaction

		update Usuarios
		set Sex=null
		where @Dni=DNI

		delete Materiales from Materiales as M
		inner join ReservasMateriales as RM on M.id=RM.IDMaterial
		inner join Reservas as R on RM.CodigoReserva=R.Codigo
		inner join Usuarios as U on R.ID_Usuario = U.ID
		where @Dni=U.DNI  

		delete ReservasMateriales from ReservasMateriales as RM
		inner join Reservas as R on RM.CodigoReserva=R.Codigo
		inner join Usuarios as U on R.ID_Usuario = U.ID
		where @Dni=U.DNI  

		delete Reservas from Reservas as R
		inner join Usuarios as U on R.ID_Usuario = U.ID
		where @Dni=U.DNI  and R.Fecha_Hora>current_timestamp
	--rollback
	commit

end
go

declare @Dni as char(9)
set @DNI='59544420G'

begin transaction

execute EliminarUsuario @Dni

rollback
go
select * from Usuarios

select * from Reservas as R
inner join Usuarios as U on R.ID_Usuario=U.ID
where U.DNI='59544420G'

select * from Usuarios
--Ejercicio 2
--Escribe un procedimiento que reciba como parámetros el código de una instalación y una fecha/hora 
--(SmallDateTime) y devuelva en otro parámetro de salida el ID del usuario que la tenía alquilada 
--si en ese momento la instalación estaba ocupada. Si estaba libre, devolverá un NULL.
go
create procedure InstalacionReservada
	@Codigo as int,
	@FechaHora as smalldatetime,
	@IDUsuario as char (12) output
as 
begin

	select @IDUsuario=
					(
		
						case
							when R.ID_Usuario is null then null
							else @IDUsuario
						end
					) 
	from Usuarios as U
	inner join Reservas as R on U.ID=R.ID_Usuario
	--inner join Instalaciones as I on R.Cod_Instalacion=I.Codigo
	where @Codigo=R.Cod_Instalacion and @FechaHora=R.Fecha_Hora

end
go

declare @Codigo as int=2582
declare	@FechaHora as smalldatetime='2008-12-12 14:00:00'
declare	@IDUsuario as char (12)

execute InstalacionReservada @Codigo,@FechaHora,@IDUsuario output

select * from Usuarios
select * from Reservas

--Ejercicio 3
--Escribe un procedimiento que reciba como parámetros el código de una instalación y dos fechas (DATE) 
--y devuelva en otro parámetro de salida el número de horas que esa instalación ha estado alquilada 
--entre esas dos fechas, ambas incluidas. Si se omite la segunda fecha, se tomará la actual con GETDATE().

--Devuelve con return códigos de error si el código de la instalación es erróneo  o si la fecha de inicio es posterior a la de fin.

--Ejercicio 4
--Escribe un procedimiento EfectuarReserva que reciba como parámetro el DNI de un usuario, el código de la 
--instalación, la fecha/hora de inicio de la reserva y la fecha/hora final.

--El procedimiento comprobará que los datos de entradas son correctos y grabará la correspondiente reserva. 
--Devolverá el código de reserva generado mediante un parámetro de salida. Para obtener el valor generado 
--usar la función @@identity tras el INSERT.

--Devuelve un cero si la operación se realiza con éxito y un código de error según la lista siguiente:

--	3: La instalación está ocupada para esa fecha y hora
--	4: El código de la instalación es incorrecto
--	5: El usuario no existe
--	8: La fecha/hora de inicio del alquiler es posterior a la de fin
--	11: La fecha de inicio y de fin son diferentes