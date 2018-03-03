use CasinOnLine2
go

--Especificaciones
--Cada apuesta tiene una serie de números (entre 1 y 24 números) asociados en la tabla COL_NumerosApuestas. 
--La apuesta es ganadora si alguno de esos números coincide con el número ganador de la jugada y perdedora en caso contrario.

--Si la apuesta es ganadora, el jugador recibe lo apostado (Importe) multiplicado por el valor de la columna Premio de la 
--tabla COL_TiposApuestas que corresponda con el tipo de la apuesta. Si la apuesta es perdedora, el jugador pierde lo que haya apostado (Importe)

--Ejercicio 1
--Escribe una consulta que nos devuelva el número de veces que se ha apostado a cada número con apuestas de los tipos 10, 13 o 15.
--Ordena el resultado de mayor a menos popularidad.
select J.Numero,A.Tipo,count(*) as [Numero de veces apostados] from COL_Jugadas as J
	inner join COL_Apuestas as A on J.IDJugada=A.IDJugada
where A.Tipo in(10,13,15)
group by J.Numero,A.Tipo
order by [Numero de veces apostados] desc

--Ejercicio 2
--El casino quiere fomentar la participación y decide regalar saldo extra a los jugadores que hayan apostado más de tres 
--veces en el último mes. Se considera el mes de febrero.
--La cantidad que se les regalará será un 5% del total que hayan apostado en ese mes

create view Ejercicio2 as
select A.IDJugador,count(A.IDJugada) as [Veces apostados],sum(A.Importe) as [Apuesta Total por jugador],sum(A.Importe)*0.05 as [Premio] from COL_Apuestas as A
	inner join COL_Jugadas as J on A.IDJugada=J.IDJugada
	inner join COL_TiposApuesta as TA on A.Tipo=TA.ID
where month(J.MomentoJuega)=2 and year(J.MomentoJuega)=2018
group by A.IDJugador
having count(A.IDJugada)>3

-----------------segunda solucion
go
create function [Regalar Saldo] (@año as smallint,@mes as smallint)
	returns table as 
		return
			(
				select A.IDJugador,count(A.IDJugada) as [Veces apostados],sum(A.Importe) as [Apuesta Total por jugador],sum(A.Importe)*0.05 as [Premio] from COL_Apuestas as A
					inner join COL_Jugadas as J on A.IDJugada=J.IDJugada
					inner join COL_TiposApuesta as TA on A.Tipo=TA.ID
				where month(J.MomentoJuega)=@mes and year(J.MomentoJuega)=@año
				group by A.IDJugador
				having count(A.IDJugada)>3
			)

declare @año smallint
declare @mes smallint

set @año=2
set @mes=2018

select * from [Regalar Saldo](@año,@mes)
go

--Ejercicio 3
--El día 2 de febrero se celebró el día de la marmota. Para conmemorarlo, el casino ha decidido volver a repetir 
--todas las jugadas que se hicieron ese día, pero poniéndoles fecha de mañana (con la misma hora) y permitiendo que 
--los jugadores apuesten. El número ganador de cada jugada se pondrá a NULL y el NoVaMas a 0.
--Crea esas nuevas filas con una instrucción INSERT-SELECT

--Ejercicio 4
--Crea una vista que nos muestre, para cada jugador, nombre, apellidos, Nick, número de apuestas realizadas, 
--total de dinero apostado y total de dinero ganado/perdido.
create view Ejercicio4Casino as
select J.Nombre,J.Apellidos,J.Nick,count(*) as [Numero de apuestas realizadas],sum(A.Importe) as [Total apostado],(sum(TA.Premio)-sum(A.Importe)) as [Ganado/Perdido] from COL_Jugadores as J
	inner join COL_Apuestas as A on J.ID=A.IDJugador
	inner join COL_TiposApuesta as TA on A.Tipo=TA.ID
group by J.Nombre,J.Apellidos,J.Nick


--Ejercicio 5
--Nos comunican que la policía ha detenido a nuestro cliente Ombligo Pato por delitos de estafa, falsedad, 
--administración desleal y mal gusto para comprar bañadores. 
--Dado que nuestro casino está en Gibraltar, siguiendo la tradición de estas tierras, queremos borrar todo 
--rastro de su paso por nuestro casino.
--Borra todas las apuestas que haya realizado, pero no busques su ID a mano en la tabla COL_Clientes. 
--Utiliza su Nick (bankiaman) para identificarlo en la instrucción DELETE.


--primero hay que eliminar todos los datos del la tabla COL_Apuestas porque el ID es clave ajena
begin transaction
delete from COL_Apuestas 
where IDJugador in (select J.ID from COL_Jugadores as J
					inner join COL_Apuestas as A on J.ID=A.IDJugador
					where J.Nick='bankiaman')
--commit
rollback

select * from COL_Apuestas as A
inner join COL_Jugadores as J on A.IDJugador=J.ID
					where J.Nick='bankiaman'

--ahora eliminaremos al jugador
begin transaction

delete from COL_Jugadores
where Nick='bankiaman'

--commit
rollback
