use CasinOnLine2
go

--Especificaciones
--Cada apuesta tiene una serie de n�meros (entre 1 y 24 n�meros) asociados en la tabla COL_NumerosApuestas. 
--La apuesta es ganadora si alguno de esos n�meros coincide con el n�mero ganador de la jugada y perdedora en caso contrario.

--Si la apuesta es ganadora, el jugador recibe lo apostado (Importe) multiplicado por el valor de la columna Premio de la 
--tabla COL_TiposApuestas que corresponda con el tipo de la apuesta. Si la apuesta es perdedora, el jugador pierde lo que haya apostado (Importe)

--Ejercicio 1
--Escribe una consulta que nos devuelva el n�mero de veces que se ha apostado a cada n�mero con apuestas de los tipos 10, 13 o 15.
--Ordena el resultado de mayor a menos popularidad.
select J.Numero,A.Tipo,count(*) as [Numero de veces apostados] from COL_Jugadas as J
	inner join COL_Apuestas as A on J.IDJugada=A.IDJugada
where A.Tipo in(10,13,15)
group by J.Numero,A.Tipo
order by [Numero de veces apostados] desc

--Ejercicio 2
--El casino quiere fomentar la participaci�n y decide regalar saldo extra a los jugadores que hayan apostado m�s de tres 
--veces en el �ltimo mes. Se considera el mes de febrero.
--La cantidad que se les regalar� ser� un 5% del total que hayan apostado en ese mes

create view Ejercicio2 as
select A.IDJugador,count(A.IDJugada) as [Veces apostados],sum(A.Importe) as [Apuesta Total por jugador],sum(A.Importe)*0.05 as [Premio] from COL_Apuestas as A
	inner join COL_Jugadas as J on A.IDJugada=J.IDJugada
	inner join COL_TiposApuesta as TA on A.Tipo=TA.ID
where month(J.MomentoJuega)=2 and year(J.MomentoJuega)=2018
group by A.IDJugador
having count(A.IDJugada)>3

-----------------segunda solucion
go
create function [Regalar Saldo] (@a�o as smallint,@mes as smallint)
	returns table as 
		return
			(
				select A.IDJugador,count(A.IDJugada) as [Veces apostados],sum(A.Importe) as [Apuesta Total por jugador],sum(A.Importe)*0.05 as [Premio] from COL_Apuestas as A
					inner join COL_Jugadas as J on A.IDJugada=J.IDJugada
					inner join COL_TiposApuesta as TA on A.Tipo=TA.ID
				where month(J.MomentoJuega)=@mes and year(J.MomentoJuega)=@a�o
				group by A.IDJugador
				having count(A.IDJugada)>3
			)

declare @a�o smallint
declare @mes smallint

set @a�o=2
set @mes=2018

select * from [Regalar Saldo](@a�o,@mes)
go

--Ejercicio 3
--El d�a 2 de febrero se celebr� el d�a de la marmota. Para conmemorarlo, el casino ha decidido volver a repetir 
--todas las jugadas que se hicieron ese d�a, pero poni�ndoles fecha de ma�ana (con la misma hora) y permitiendo que 
--los jugadores apuesten. El n�mero ganador de cada jugada se pondr� a NULL y el NoVaMas a 0.
--Crea esas nuevas filas con una instrucci�n INSERT-SELECT

--Ejercicio 4
--Crea una vista que nos muestre, para cada jugador, nombre, apellidos, Nick, n�mero de apuestas realizadas, 
--total de dinero apostado y total de dinero ganado/perdido.
create view Ejercicio4Casino as
select J.Nombre,J.Apellidos,J.Nick,count(*) as [Numero de apuestas realizadas],sum(A.Importe) as [Total apostado],(sum(TA.Premio)-sum(A.Importe)) as [Ganado/Perdido] from COL_Jugadores as J
	inner join COL_Apuestas as A on J.ID=A.IDJugador
	inner join COL_TiposApuesta as TA on A.Tipo=TA.ID
group by J.Nombre,J.Apellidos,J.Nick


--Ejercicio 5
--Nos comunican que la polic�a ha detenido a nuestro cliente Ombligo Pato por delitos de estafa, falsedad, 
--administraci�n desleal y mal gusto para comprar ba�adores. 
--Dado que nuestro casino est� en Gibraltar, siguiendo la tradici�n de estas tierras, queremos borrar todo 
--rastro de su paso por nuestro casino.
--Borra todas las apuestas que haya realizado, pero no busques su ID a mano en la tabla COL_Clientes. 
--Utiliza su Nick (bankiaman) para identificarlo en la instrucci�n DELETE.


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
