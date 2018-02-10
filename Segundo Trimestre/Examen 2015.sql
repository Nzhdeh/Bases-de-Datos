
use Flamenco
go

--Tenemos una base de datos sobre cantaores flamencos. Los artistas cantan diferentes "Palos". 
--Un mismo palo puede ser cantado por diferentes cantaores.

--Tambien registramos pe�as flamencas, que est�n repartidas por diferentes localidades. Los artistas act�an en las pe�as.

--Las pe�as organizan festivales por periodicidad anual. En esos festivales act�an los artistas.

--Ejercicio 1
--Numero de veces que ha actuado cada cantaor en cada festival de Cadiz, incluyendo a los que no han actuado nunca.
select F.Cod,count(C.Codigo) as [Numero de actuaciones] from F_Festivales as F
inner join F_Festivales_Cantaores as FC on F.Cod=FC.Cod_Festival
right join F_Cantaores as C on FC.Cod_Cantaor=C.Codigo
where C.Cod_Provincia='CA'
group by F.Cod
go

--Ejercicio 2
----Crea un nuevo palo llamado "Ton�"
insert into F_Palos
		(Cod_Palo,Palo)
values  ('TO','Ton�')
go
/*
insert into F_Palos_Cantaor
			(Cod_cantaor,Cod_Palo)
	values	('0251','TO')
*/
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Ton�s. No utilices los codicos de los palos, sino sus nombres.
select * from F_Palos_Cantaor
select * from F_Palos
update F_Palos_Cantaor
set
--Ejercicio 3
--N�mero de los cantaores mayores de 30 a�os que han actuado cada a�o en cada pe�a. Se contara la edad que ten�an en el a�o de la actuacion

--Ejercicio 4
--Cantaores (Nombre, Apellidos, Nombre artistico) que hayan actuado mas de dos veces en pe�a de la provincia de Sevilla y 
--cantan Fandandos o Buler�as. Solo se incluyen las actuaciones directasen pe�as, no los festivales.

--Ejercicio 5
--Numero de actuaciones que se han celebrado en cada pe�a incluyendo las actuaciones directas y en festivales. incluyendo el nombre de la pe�a
--y la localidad.

 