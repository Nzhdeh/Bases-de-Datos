use LeoTurfTest
go
--1. Quiero saber el importe ganado por cada jugador en el dia de hoy
select * from LTCarreras

select J.ID,J.Nombre,J.Apellidos,(A.Importe*CC.Premio1) as [Premio ganado] from LTJugadores as J
inner join LTApuestas as A on J.ID=A.IDJugador
inner join LTCarreras as C on A.IDCarrera=C.ID
inner join LTCaballosCarreras as CC on A.IDCarrera=CC.IDCarrera and A.IDCaballo=CC.IDCaballo
where C.Fecha='2015-01-20'


--2. El premio maximo por ciudad
select J.Nombre,J.Apellidos,J.Ciudad,[Premios maximos].[Premio maximo1],[Premios maximos].[Premio maximo2] from LTJugadores as J
inner join LTApuestas as A on J.ID=A.IDJugador
inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
inner join 
		(
			select [Todos los premios].Ciudad,max([Todos los premios].Premio1) as [Premio maximo1],max([Todos los premios].Premio2) as [Premio maximo2] from LTJugadores as J
			inner join LTApuestas as A on J.ID=A.IDJugador
			inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
			inner join 
					(
						select J.ID,J.Nombre,J.Apellidos,J.Ciudad,CC.Premio1,CC.Premio2 from LTJugadores as J
						inner join LTApuestas as A on J.ID=A.IDJugador
						inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
					) as [Todos los premios] on J.Ciudad=[Todos los premios].Ciudad
			group by [Todos los premios].Ciudad
		)as [Premios maximos] on J.Ciudad=[Premios maximos].Ciudad
group by J.Nombre,J.Apellidos,J.Ciudad,[Premios maximos].[Premio maximo1],[Premios maximos].[Premio maximo2]


--3. Caballo con mas confianza(en los que mas se ha apostado) por carrera
select [Maximo].ID,[Maximo].Nombre,[Maximo].[Apuesta maxima] from LTCaballos as C
inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
inner join LTApuestas as A on CC.IDCaballo=A.IDCaballo and CC.IDCarrera=A.IDCarrera
inner join
		(
			select [Todas las veces apostadas].ID,[Todas las veces apostadas].Nombre,max([Todas las veces apostadas].[Veces apostados]) as [Apuesta maxima] from LTCaballos as C
			inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
			inner join LTApuestas as A on CC.IDCaballo=A.IDCaballo and CC.IDCarrera=A.IDCarrera
			inner join 
					(
						select C.ID,C.Nombre,Count(*) as [Veces apostados] from LTCaballos as C
						inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
						inner join LTApuestas as A on CC.IDCaballo=A.IDCaballo and CC.IDCarrera=A.IDCarrera
						group by C.ID,C.Nombre
					)as [Todas las veces apostadas] on C.ID=[Todas las veces apostadas].ID
			group by [Todas las veces apostadas].ID,[Todas las veces apostadas].Nombre
		)as [Maximo] on C.ID=Maximo.ID
group by [Maximo].ID,[Maximo].Nombre,[Maximo].[Apuesta maxima]
having count(C.ID)=Maximo.[Apuesta maxima]



--4. El nombre del caballo que mas veces ha ganado
create view [Caballo ganador] as
select CC.IDCaballo,CC.IDCarrera,count(*) as [Veces ganado] from LTCaballosCarreras as CC
group by CC.IDCaballo,CC.IDCarrera

select C.Nombre,CG.IDCaballo,CG.IDCarrera from [Caballo ganador] as CG
inner join LTCaballos as C on CG.IDCaballo = C.ID

--5. Jugadores que han apostado por dos o mas caballos

select [Caballos].ID,[Caballos].Nombre,[Caballos].Apellidos,[Caballos].[Numero de caballos apostados] from LTJugadores as J
inner join LTApuestas as A on J.ID=A.IDJugador
inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
inner join 
		(
			select J.ID,J.Nombre,J.Apellidos,count (*) as [Numero de caballos apostados] from LTJugadores as J
			inner join LTApuestas as A on J.ID=A.IDJugador
			inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
			group by J.ID,J.Nombre,J.Apellidos
		) as [Caballos] on J.ID=[Caballos].ID
group by [Caballos].ID,[Caballos].Nombre,[Caballos].Apellidos,[Caballos].[Numero de caballos apostados]
having [Caballos].[Numero de caballos apostados]>2


select * from LTCaballos
where ID=31

--6. Caballos que corren en el hipodromo "Gran Hipodromo de Andalucia"
select C.ID,C.Nombre from LTCaballos as C
inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
inner join LTCarreras as CS on CC.IDCarrera=CS.ID
where CS.Hipodromo='Gran Hipodromo de Andalucia'


select C.ID,C.Nombre from LTCaballos as C
inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
inner join LTCarreras as CS on CC.IDCarrera=CS.ID
where CS.Hipodromo='La Zarzuela'

--7.Inserta un nuevo caballo y asignale las carreras de "Ciclon"
begin transaction

insert into [dbo].[LTCaballos]
           ([ID]
           ,[Nombre]
           ,[FechaNacimiento]
           ,[Sexo])
     values( 31,'Bucefalo                      ','2010-2-2','H')

rollback

--select C.ID,C.Hipodromo,C.Fecha,C.NumOrden from LTCarreras as C 
--inner join LTCaballosCarreras as CC on C.ID=CC.IDCarrera
--inner join LTCaballos as CB on CC.IDCaballo=CB.ID
--where CB.Nombre='Ciclon'

insert into [dbo].[LTCarreras]
           ([ID]
           ,[Hipodromo]
           ,[Fecha]
           ,[NumOrden])
		   select 31,[Hipodromo],[Fecha],[NumOrden] from LTCarreras as C 
			inner join LTCaballosCarreras as CC on C.ID=CC.IDCarrera
			inner join LTCaballos as CB on CC.IDCaballo=CB.ID
			where CB.Nombre='Ciclon'
