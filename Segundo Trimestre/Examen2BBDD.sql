use LeoTurf
go
--Especificaciones
--La web LeoTurf ofrece a sus usuarios la posibilidad de realizar apuestas en las carreras de caballos.
--Para ello dispone de la base de datos LeoTurf que contiene la información relativa a las carreras, 
--los caballos que participan en ellas y sus resultados.
--Los usuarios deben estar registrados para poder realizar apuestas. Sus datos se guardan en la tabla LTJugadores.
--Los datos relevantes para una apuesta son el caballo por el que se apuesta, la carrera y el importe de la apuesta. 
--Si el caballo finaliza la carrera después del segundo, el jugador pierde. Si el caballo gana la carrera, el jugador 
--gana el importe apostado multiplicado por el valor de la columna Premio1 de la tabla LTCaballosCarreras correspondiente 
--a ese caballo y esa carrera. Si el caballo finaliza en segunda posición, la ganancia será el importe apostado 
--multiplicado por el valor de la columna Premio2 de la fila correspondiente.
--Cuando un jugador se registra hace una aportación inicial que es el saldo de que dispone para realizar apuestas. 
--Cada vez que apueste, se creará un apunte en el que se detraerá el importe apostado. Si la apuesta es ganadora, 
--se incrementará el saldo con el premio que corresponda.
--Los jugadores pueden aportar más dinero a la cuenta para hacer apuestas y también retirar saldo de la misma. 
--Es ambos casos se generará también un apunte con la operación.


--Ejercicio 1
--Queremos saber cuál es la cantidad media apostada y la mayor cantidad apostada a cada caballo.
--Columnas: ID Caballo, Nombre, Edad, Número de carreras disputadas, cantidad mayor apostada y cantidad media apostada a su favor


create view [Dinero apostado por cada caballo] as
select C.ID,C.Nombre,A.Importe from LTApuestas as A
inner join LTCaballos as C on A.IDCaballo=C.ID
--group by C.ID,C.Nombre,A.Importe,C.FechaNacimiento

select DAC.Nombre,avg(DAC.Importe) as [Cantidad media],max(DAC.Importe ) as [Cantidad maxima],Year(Current_Timestamp)-Year (C.FechaNacimiento) as [Edad],count(*) [Numero de carreras disputadas]  from [Dinero apostado por cada caballo] as DAC
inner join LTCaballos as C on DAC.ID=C.ID
inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
group by DAC.Nombre,C.FechaNacimiento


--Ejercicio 2
--Tenemos sospechas de que algún jugador pueda estar intentando amañar las carreras. Queremos detectar los 
--jugadores que son especialmente afortunados. 
--Haz una consulta que calcule, para cada jugador, la rentabilidad que obtiene con el menor riesgo posible. 
--La rentabilidad se mide dividiendo el total de dinero ganado entre el dinero apostado y multiplicando el resultado por 100.
--Ten en cuenta solo el dinero que haya ganado por premios, no los ingresos que haya podido hacer en su cuenta.
--Columnas: ID, nombre y apellidos del jugador, total de dinero apostado, total de dinero ganado, rentabilidad.

select J.ID,J.Nombre,J.Apellidos,sum(A.Importe) as [Total apostado],sum(CC.Premio1)+sum(CC.Premio2) as [Total ganado],((sum(CC.Premio1)+sum(CC.Premio2))/sum(A.Importe))*100 as [Rentabilidad] from LTCaballosCarreras as CC
inner join LTCaballos as C on CC.IDCaballo=C.ID
inner join LTApuestas as A on C.ID=A.IDCaballo
inner join LTJugadores as J on A.IDJugador=J.ID
group by J.ID,J.Nombre,J.Apellidos


--Ejercicio 3
--Como todavía no estamos tranquilos, vamos a comprobar apuestas que se salgan de lo normal. 
--Consideramos sospechosa una apuesta ganadora grande (al menos un 50% por encima del importe 
--medio de las apuestas de esa carrera) a caballos que se pagasen a 2 o más. 
--Columnas: ID Jugador, Nombre, apellidos, ID apuesta, Hipódromo, fecha de la carrera, caballo, premio, importe apostado e importe ganado.
--Si no devuelve ninguna fila no pasa nada. Nuestros clientes son honrados.
create view [Importe medio] as
select ID,IDCarrera,IDCaballo,IDJugador,Importe,avg(Importe) as [Importe medio por Carrera] from LTApuestas
group by ID,IDCarrera,IDCaballo,IDJugador,Importe

create view [Ganancias Mas de 50%] as
select IM.IDCaballo,CC.Premio1,CC.Premio2 from [Importe medio] as IM
inner join LTCaballosCarreras as CC on IM.IDCaballo=CC.IDCaballo and IM.IDCarrera=CC.IDCarrera
where [Importe medio por Carrera]<(CC.Premio1+CC.Premio2)*0.5 and CC.Posicion=2


select J.ID,J.Apellidos,J.Nombre,IM.ID,C.Hipodromo,C.Fecha,IM.IDCaballo,GM.Premio1,GM.Premio2,IM.Importe as [Importe apostado],GM.Premio1+GM.Premio2 as [Importe ganado] from LTJugadores as J
inner join [Importe medio] as IM on J.ID=IM.IDJugador
inner join LTCarreras as C on IM.IDCarrera=C.ID
inner join [Ganancias Mas de 50%] as GM on IM.IDcaballo=GM.IDCaballo


--Elige uno de los siguientes

--Ejercicio 5a
--Ya tenemos los resultados de la carrera 21:

--  Posicion		| Caballo	| IDCaballo
--		1				Fiona		11
--		2				Vetonia		7
--		3				Witiza		19
--		4				Sigerico	12
--		5				Galatea		5
--		6				Desdemona	16
--	no Finalizado		Ciclon		1

--Actualiza la tabla LTCaballosCarreras y genera los apuntes en LTApuntes correspondientes a los 
--jugadores que hayan ganado utilizando dos instrucciones INSERT-SELECT,
-- una para los que han acertado la ganadora y otra para los que han acertado la segunda.


select * from LTCaballosCarreras as CC
inner join LTCaballos as C on Cc.IDCaballo=C.ID
where C.Nombre='Fiona' and CC.IDCarrera=21


begin transaction 
	update LTCaballosCarreras
			set Posicion=1
		where IDCarrera =21 and IDCaballo in (select C.ID from LTCaballosCarreras as CC
												inner join LTCaballos as C on Cc.IDCaballo=C.ID
												where C.Nombre='Fiona')


	update LTCaballosCarreras
			set Posicion=2
		where IDCarrera =21 and IDCaballo in (select C.ID from LTCaballosCarreras as CC
												inner join LTCaballos as C on Cc.IDCaballo=C.ID
												where C.Nombre='Vetonia')

	update LTCaballosCarreras
			set Posicion=3
		where IDCarrera =21 and IDCaballo in (select C.ID from LTCaballosCarreras as CC
												inner join LTCaballos as C on Cc.IDCaballo=C.ID
												where C.Nombre='Witiza')

	update LTCaballosCarreras
			set Posicion=4
		where IDCarrera =21 and IDCaballo in (select C.ID from LTCaballosCarreras as CC
												inner join LTCaballos as C on Cc.IDCaballo=C.ID
												where C.Nombre='Sigerico')


	update LTCaballosCarreras
			set Posicion=5
		where IDCarrera =21 and IDCaballo in (select C.ID from LTCaballosCarreras as CC
												inner join LTCaballos as C on Cc.IDCaballo=C.ID
												where C.Nombre='Galatea')

	update LTCaballosCarreras
			set Posicion=6
		where IDCarrera =21 and IDCaballo in (select C.ID from LTCaballosCarreras as CC
												inner join LTCaballos as C on Cc.IDCaballo=C.ID
												where C.Nombre='Desdemona')

	update LTCaballosCarreras	--este ultimo no hace falta actualizarlo porque ya esta a null
			set Posicion=null
		where IDCarrera =21 and IDCaballo in (select C.ID from LTCaballosCarreras as CC
												inner join LTCaballos as C on Cc.IDCaballo=C.ID
												where C.Nombre='Ciclon')
--commit
rollback

select * from LTApuntes


begin transaction
insert into [dbo].[LTApuntes]
           ([IDJugador]
           ,[Orden]
           ,[Fecha]
           ,[Importe]
           ,[Saldo]
           ,[Concepto])
		   select J.[ID],
					A.[Orden],
					C.[Fecha],
					A.Importe,
					A.Saldo ,
					'Apuesta 1'
		   from LTApuntes as A
		   inner join LTJugadores as J on A.IDJugador=J.ID
		   inner join LTApuestas as AP on J.ID=AP.IDJugador
		   inner join LTCaballosCarreras as CC on AP.IDCaballo=CC.IDCaballo and AP.IDCarrera=CC.IDCarrera
		   inner join LTCarreras as C on AP.IDCarrera=C.ID
		   where CC.IDCarrera=21 and CC.Posicion=1

		   --segundo insert select
insert into [dbo].[LTApuntes]
           ([IDJugador]
           ,[Orden]
           ,[Fecha]
           ,[Importe]
           ,[Saldo]
           ,[Concepto])

		   select J.[ID],
					A.[Orden],
					C.[Fecha],
					A.Importe,
					A.Saldo,
					'Apuesta 2'
		   from LTApuntes as A
		   inner join LTJugadores as J on A.IDJugador=J.ID
		   inner join LTApuestas as AP on J.ID=AP.IDJugador
		   inner join LTCaballosCarreras as CC on AP.IDCaballo=CC.IDCaballo and AP.IDCarrera=CC.IDCarrera
		   inner join LTCarreras as C on AP.IDCarrera=C.ID
		   where CC.IDCarrera=21 and CC.Posicion=2
rollback

--Ejercicio 5b
--Debido a una reclamación, el caballo Ciclón ha sido descalificado en la carrera 11 por 
--utilizar herraduras de fibra de carbono, prohibidas por el reglamento.
--Actualiza la tabla LTCaballosCarreras haciendo que la posición de Ciclón sea NULL 
--y todos los que entraron detrás de él suban un puesto. 
--Como Ciclón quedó segundo, este cambio afecta a los premios. Hay que anular (eliminar) 
--todos los apuntes relativos a premios por ese caballo en esa carrera.
--Además, el segundo pasa a ser primero y el tercero pasa a ser segundo, lo que afecta a sus apuestas.
-- Genera o modifica los apuntes correspondientes a esos premios.
