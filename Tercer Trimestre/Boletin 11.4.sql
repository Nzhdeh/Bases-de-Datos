use CentroDeportivo
go

--Sobre la base de datos CentroDeportivo.

--Ejercicio 1
--Escribe un procedimiento EliminarUsuario que reciba como par�metro el DNI de un usuario, 
--le coloque un NULL en la columna Sex y borre todas las reservas futuras de ese usuario. 
--Ten en cuenta que si alguna de esas reservas tiene asociado un alquiler de material habr� que borrarlo tambi�n.

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
--Escribe un procedimiento que reciba como par�metros el c�digo de una instalaci�n y una fecha/hora 
--(SmallDateTime) y devuelva en otro par�metro de salida el ID del usuario que la ten�a alquilada 
--si en ese momento la instalaci�n estaba ocupada. Si estaba libre, devolver� un NULL.
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
--Escribe un procedimiento que reciba como par�metros el c�digo de una instalaci�n y dos fechas (DATE) 
--y devuelva en otro par�metro de salida el n�mero de horas que esa instalaci�n ha estado alquilada 
--entre esas dos fechas, ambas incluidas. Si se omite la segunda fecha, se tomar� la actual con GETDATE().

--Devuelve con return c�digos de error si el c�digo de la instalaci�n es err�neo  o si la fecha de inicio es posterior a la de fin.

--Ejercicio 4
--Escribe un procedimiento EfectuarReserva que reciba como par�metro el DNI de un usuario, el c�digo de la 
--instalaci�n, la fecha/hora de inicio de la reserva y la fecha/hora final.

--El procedimiento comprobar� que los datos de entradas son correctos y grabar� la correspondiente reserva. 
--Devolver� el c�digo de reserva generado mediante un par�metro de salida. Para obtener el valor generado 
--usar la funci�n @@identity tras el INSERT.

--Devuelve un cero si la operaci�n se realiza con �xito y un c�digo de error seg�n la lista siguiente:

--	3: La instalaci�n est� ocupada para esa fecha y hora
--	4: El c�digo de la instalaci�n es incorrecto
--	5: El usuario no existe
--	8: La fecha/hora de inicio del alquiler es posterior a la de fin
--	11: La fecha de inicio y de fin son diferentes