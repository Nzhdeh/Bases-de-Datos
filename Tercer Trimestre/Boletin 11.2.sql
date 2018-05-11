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
	declare @Codigo as int 
	select top 1 @Codigo=ID+1 from LTJugadores	--calcula el ultimo jugador y le suma 1

	insert into LTJugadores (ID,Nombre,Apellidos,Direccion,Telefono,Ciudad)
	values(@Codigo,@Nombre,@Apellidos,@Direccion,@Telefono,@Ciudad)

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

	declare @var as smallint
	declare @inscrito as bit
	declare @caballoExiste as bit

	set @var=(select count(IDCaballo) from LTCaballosCarreras
						where @IDCarrera=IDCarrera)

	if exists (select * from LTCaballosCarreras
				where @IDCarrera=IDCarrera and @IDCaballo=IDCaballo)
	begin 
		set @inscrito = 1
	end

	else
	begin 
		set @inscrito = 0
	end
	
	if exists (select * from LTCaballosCarreras
				where @IDCarrera=IDCarrera and @IDCaballo=IDCaballo
				)
	begin 
		set @caballoExiste = 1
	end

	else
	begin 
		set @caballoExiste = 0
	end

	insert into LTCaballosCarreras(IDCaballo,IDCarrera,Numero,Posicion,Premio1,Premio2)
	values(@IDCaballo,@IDCarrera,round(((99-1-1)*rand()+1),0),null,2.5,5)

	select @NumeroAsignado=
		
		(
			case 
				when CA.ID is null then null
				when @var>=8  then null
				when @inscrito=1 then null 
				when @caballoExiste=1 then null
				else @NumeroAsignado
			end 
		)

	 from LTCaballos as C
	inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
	inner join LTCarreras as CA on CC.IDCarrera=CA.ID
end

go

declare @IDCaballo as smallint =99
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


--Circunstancia								|		valor


--La carrera no existe						|		2
			
--La carrera ya se ha disputado				|		3

--El caballo no corre en esa carrera		|		5

--El saldo del jugador no es suficiente		|		10

--Ninguna de las anteriores					|		0
go
alter table LTJugadores add LimiteCredito smallmoney 
go
alter table LTJugadores add constraint DF_LimiteCredito default 50 for LimiteCredito
go

update LTJugadores 
set LimiteCredito = 50

go
select * from LTJugadores
go

alter procedure GrabarApuesta

		@IDJugador as int,
		@IDCarrera as smallint,
		@IDCaballo as smallint,
		@Importe as smallmoney
as 

	begin 
		declare	@codigoTerminacion as tinyint
		declare @existeCaballoCarrera as bit

		if exists (select * from LTCaballosCarreras
					where @IDCarrera=IDCarrera and @IDCaballo=IDCaballo
					)
			begin 
				set @existeCaballoCarrera=1
			end

		else
			begin 
				set @existeCaballoCarrera=0
			end

		select @CodigoTerminacion=
		(
			case
				when C.ID is null then 2
				when C.Fecha<CURRENT_TIMESTAMP then 3
				when @existeCaballoCarrera=0 then 5
				when Ap.Saldo<1 then 10
				else 0
			end
		) 
		from LTApuestas as A
			inner join LTCarreras as C on A.IDCarrera=C.ID
			inner join LTJugadores as J on A.IDJugador=J.ID
			inner join LTApuntes as AP on J.ID=AP.IDJugador
		where @IDJugador=J.ID and @IDCarrera=C.ID and @IDCaballo=A.IDCaballo and @Importe=A.Importe

		return @codigoTerminacion

		if @codigoTerminacion=0

		begin 
			--hay que insertar la apuesta
		end
	end
go

declare @IDJugador as int =1
declare	@IDCarrera as smallint =1
declare	@IDCaballo as smallint=1
declare	@Importe as smallmoney =50
declare @Codigo as tinyint

execute @Codigo= GrabarApuesta @IDJugador,@IDCarrera,@IDCaballo, @Importe

select @Codigo

--print @Codigo --el resultado esta en mensajes

select * from LTCarreras
go
--4.Algunas veces se bonifica a los jugadores que más apuestan regalándoles saldo extra. Escribe un procedimiento AplicarBonificacion 
--que reciba como parámetros un rango de fechas, la cantidad mínima apostada para tener derecho a la bonificación y la cuantía de la bonificación. 
--También un parámetro de tipo bit. Si ese parámetro vale 0, la bonificación se entiende como una cantidad de dinero que se suma a todos los que 
--cumplan los criterios de fecha y cantidad apostada. Si el parámetro vale 1, la bonificación que hay que sumar será igual a un porcentaje del 
--total apostado entre esas dos fechas. En este segundo caso, el valor de la bonificación no podrá ser superior a 10.
--El procedimiento debe generar los apuntes que correspondan con el concepto "Bonificación”
go
drop function TotalApostado
go
create function TotalApostado(@FechaIni as date,@FechaFin as date)--creo esta funcion,para llamarla en el procedimiento
	returns table as
		return 
		(
			select A.ID,sum(A.Importe) as [Total apostado] from LTApuestas as A
			inner join LTCarreras as C on A.IDCarrera=C.ID
			where C.Fecha between @FechaIni and @FechaFin
			group by A.ID
		)
go

declare @FechaIni as date
declare @FechaFinal as date

set @FechaIni='20000225'
set @FechaFinal ='20200226'

select * from TotalApostado (@FechaIni,@FechaFinal)
go

create procedure AplicarBonificacion
	
		@ApuestaMinima as double,
		@FechaIni as date,
		@FechaFin as date,
		@CuantiaBonificacion as double
		
as

begin
	declare @Variable as bit

	select @Variable=
			(
			case 
				when then 0
			)
	 from LTApuestas
end

--5.Escribe un procedimiento almacenado que calcule y actualice los valores de las columnas Premio1 y Premio2 de la tabla LTCaballosCarreras. 
--El procedimiento recibirá un parámetro que será el ID de la carrera y devolverá un código de error en un parametro de salida que valdrá 1 
--si la carrera ya se ha disputado, 3 si no existe y 0 en los demás casos.
--Los valores de Premio1 y Premio2 se calcularán de acuerdo a las instrucciones del ejercicio 4 del boletín 11.0.