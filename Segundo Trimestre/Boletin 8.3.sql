
--Base de datos: AdventureWorks2012
use AdventureWorks2012
go

--Consultas sencillas

--1.Nombre del producto, código y precio, ordenado de mayor a menor precio
--select * from Production.Product
select [Name],ProductNumber,ListPrice from Production.Product
order by ListPrice desc
go

--2.Número de direcciones de cada Estado/Provincia

--3.Nombre del producto, código, número, tamaño y peso de los productos que estaban a 
--la venta durante todo el mes de septiembre de 2002. No queremos que aparezcan aquellos 
--cuyo peso sea superior a 2000.
select Name,ProductID,ProductNumber,Size,[Weight] from Production.Product
where SellStartDate<'31-8-2002' and SellEndDate>'30-9-2002' and [Weight]<=2000

--4.Margen de beneficio de cada producto (Precio de venta menos el coste), y porcentaje 
--que supone respecto del precio de venta.
select ListPrice-StandardCost as [Margen de Beneficio],(100*(ListPrice-StandardCost))/StandardCost as [Porcentaje] from Production.Product
where StandardCost!=0


--Consultas de dificultad media

--5.Número de productos de cada categoría

--6.Igual a la anterior, pero considerando las categorías generales (categorías de categorías).

--7.Número de unidades vendidas de cada producto cada año.

--8.Nombre completo, compañía y total facturado a cada cliente

--9.Número de producto, nombre y precio de todos aquellos en cuya descripción aparezcan 
--las palabras "race”, "competition” o "performance”


--Consultas avanzadas

--10.Facturación total en cada país

--11.Facturación total en cada Estado

--12.Margen medio de beneficios y total facturado en cada país
