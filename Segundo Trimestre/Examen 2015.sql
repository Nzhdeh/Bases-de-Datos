
use Flamenco
go

--Tenemos una base de datos sobre cantaores flamencos. Los artistas cantan diferentes "Palos". 
--Un mismo palo puede ser cantado por diferentes cantaores.

--Tambien registramos peñas flamencas, que están repartidas por diferentes localidades. Los artistas actúan en las peñas.

--Las peñas organizan festivales por periodicidad anual. En esos festivales actúan los artistas.

--Ejercicio 1
--Numero de veces que ha actuado cada cantaor en cada festival de Cadiz, incluyendo a los que no han actuado nunca.
select F.Cod,count(C.Codigo) as [Numero de actuaciones] from F_Festivales as F
inner join F_Festivales_Cantaores as FC on F.Cod=FC.Cod_Festival
right join F_Cantaores as C on FC.Cod_Cantaor=C.Codigo
where C.Cod_Provincia='CA'
group by F.Cod
go

--Ejercicio 2
----Crea un nuevo palo llamado "Toná"
insert into F_Palos
		(Cod_Palo,Palo)
values  ('TO','Toná')
go
/*
insert into F_Palos_Cantaor
			(Cod_cantaor,Cod_Palo)
	values	('0251','TO')
*/
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Tonás. No utilices los codicos de los palos, sino sus nombres.
select * from F_Palos_Cantaor
select * from F_Palos
update F_Palos_Cantaor
set
--Ejercicio 3
--Número de los cantaores mayores de 30 años que han actuado cada año en cada peña. Se contara la edad que tenían en el año de la actuacion

--Ejercicio 4
--Cantaores (Nombre, Apellidos, Nombre artistico) que hayan actuado mas de dos veces en peña de la provincia de Sevilla y 
--cantan Fandandos o Bulerías. Solo se incluyen las actuaciones directasen peñas, no los festivales.

--Ejercicio 5
--Numero de actuaciones que se han celebrado en cada peña incluyendo las actuaciones directas y en festivales. incluyendo el nombre de la peña
--y la localidad.

 