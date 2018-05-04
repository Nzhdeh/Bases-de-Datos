use LeoTurf
go

--1.Escribe un procedimiento para dar de alta un nuevo jugador. Los parámetros de entrada serán todos los datos del jugador 
--y la cantidad de su aportación inicial para apostar.
--El procedimiento insertará al jugador y generará su primer apunte.

create procedure DarDeAltaJugador

	@ID as int,
	@Nombre as varchar (20),
	@Apellidos as varchar (30),
	@Direccion as varchar (50),
	@Telefono as char (9),
	@Ciudad as varchar (20),
	@CantApostado smallmoney

as

begin
	insert into LTJugadores (ID,Nombre,Apellidos,Direccion,Telefono,Ciudad)
	values(@ID,@Nombre,@Apellidos,@Direccion,@Telefono,@Ciudad)

	insert into LTApuntes(IDJugador,Orden,Fecha,Importe,Saldo,Concepto)
	values(@ID,241,'20180504',@CantApostado,150,'Apuesta 1')
end

go


execute DarDeAltaJugador @ID = 45,
						 @Nombre = 'Nzhdeh',
						 @Apellidos = 'Yeghiazaryan',
						 @Direccion = 'No disponible en estos momentos',
						 @Telefono = '123456789',
						 @Ciudad = 'Sevilla',
						 @CantApostado = 5.9

select * from LTJugadores
where ID=45

select * from LTApuntes
where Orden=241

go
--delete from LTApuntes
--where Orden=241
--delete from LTJugadores
--where ID=45

--2.Escribe un procedimiento para inscribir un caballo en una carrera. El procedimiento tendrá como parámetros de entrada el ID 
--de la carrera y el ID del caballo, y devolverá un parámetro de salida que indicará el número asignado al caballo en esa carrera. 
--El número estará comprendido entre 1 y 99 y lo puedes asignar por el método que quieras, aunque teniendo en cuenta que no puede 
--haber dos caballos con el mismo número en una carrera. Si la carrera no existe, si hay ocho caballos ya inscritos o si el caballo 
--no existe o está ya inscrito en esa carrera, el parámetro de salida devolverá NULL.

create procedure InscribirCaballo
	
		@IDCaballo as smallint,
		@IDCarrera as smallint,
		@NumeroAsignado as tinyint output

as

begin 
	insert into LTCaballosCarreras(IDCaballo,IDCarrera,Numero,Posicion,Premio1,Premio2)
	values(@IDCaballo,@IDCarrera,round(((99-1-1)*rand()+1),0),null,2.5,5)

	select @NumeroAsignado=
		
		(
			case 
				when CA.ID=null then @NumeroAsignado=null
				when (select count(IDCaballo) from LTCaballosCarreras
						where ) then @NumeroAsignado=null
			end
		)

	 from LTCaballos as C
	inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
	inner join LTCarreras as CA on CC.IDCarrera=CA.ID
end

go

declare @IDCaballo as smallint =1
declare @IDCarrera as smallint =2
declare @NumeroAsignado as tinyint

execute InscribirCaballo @IDCaballo,@IDCarrera,@NumeroAsignado output

select * from LTCaballosCarreras
where Numero=1
go
--3.Añade a la tabla LTJugadores una nueva columna llamada LimiteCredito de tipo SmallMoney con el valor por defecto 50. 
--Este valor indicará el máximo saldo negativo que se permite al jugador. El saldo del jugador más el valor de esa columna 
--no puede ser nunca inferior a 0.
--Escribe un procedimiento para grabar una apuesta. El procedimiento recibirá como parámetros el jugador, la carrera, 
--el caballo y el importe a apostar y devolverá con return un código de terminación según la siguiente tabla:


--Circunstancia										valor


--La carrera no existe								2
			
--La carrera ya se ha disputado						3

--El caballo no corre en esa carrera				5

--El saldo del jugador no es suficiente				10

--Ninguna de las anteriores							0

--4.Algunas veces se bonifica a los jugadores que más apuestan reglándoles saldo extra. Escribe un procedimiento AplicarBonificacion 
--que reciba como parámetros un rango de fechas, la cantidad mínima apostada para tener derecho a la bonificación y la cuantía de la bonificación. 
--También un parámetro de tipo bit. Si ese parámetro vale 0, la bonificación se entiende como una cantidad de dinero que se suma a todos los que 
--cumplan los criterios de fecha y cantidad apostada. Si el parámetro vale 1, la bonificación que hay que sumar será igual a un porcentaje del 
--total apostado entre esas dos fechas. En este segundo caso, el valor de la bonificación no podrá ser superior a 10.
--El procedimiento debe generar los apuntes que correspondan con el concepto "Bonificación”

--5.Escribe un procedimiento almacenado que calcule y actualice los valores de las columnas Premio1 y Premio2 de la tabla LTCaballosCarreras. 
--El procedimiento recibirá un parámetro que será el ID de la carrera y devolverá un código de error en un parametro de salida que valdrá 1 
--si la carrera ya se ha disputado, 3 si no existe y 0 en los demás casos.
--Los valores de Premio1 y Premio2 se calcularán de acuerdo a las instrucciones del ejercicio 4 del boletín 11.0.