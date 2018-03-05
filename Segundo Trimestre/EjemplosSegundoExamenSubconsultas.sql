use LeoTurfTest
go
--1. Quiero saber el importe ganado por cada jugador en el dia de hoy
select * from LTCarreras

select J.ID,J.Nombre,J.Apellidos,(A.Importe*CC.Premio1) as [Premio ganado] from LTJugadores as J
inner join LTApuestas as A on J.ID=A.IDJugador
inner join LTCarreras as C on A.IDCarrera=C.ID
inner join LTCaballosCarreras as CC on A.IDCarrera=CC.IDCarrera and A.IDCaballo=CC.IDCaballo
where C.Fecha='2015-01-20'