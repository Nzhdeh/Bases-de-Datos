
--Base de datos: AdventureWorks2012
use AdventureWorks2012
go

--Consultas sencillas

--1.Nombre del producto, c�digo y precio, ordenado de mayor a menor precio
--select * from Production.Product
select [Name],ProductNumber,ListPrice from Production.Product
order by ListPrice desc
go

--2.N�mero de direcciones de cada Estado/Provincia

--3.Nombre del producto, c�digo, n�mero, tama�o y peso de los productos que estaban a 
--la venta durante todo el mes de septiembre de 2002. No queremos que aparezcan aquellos 
--cuyo peso sea superior a 2000.
select Name,ProductID,ProductNumber,Size,[Weight] from Production.Product
where SellStartDate<'31-8-2002' and SellEndDate>'30-9-2002' and [Weight]<=2000

--4.Margen de beneficio de cada producto (Precio de venta menos el coste), y porcentaje 
--que supone respecto del precio de venta.
select ListPrice-StandardCost as [Margen de Beneficio],(100*(ListPrice-StandardCost))/StandardCost as [Porcentaje] from Production.Product
where StandardCost!=0


--Consultas de dificultad media

--5.N�mero de productos de cada categor�a
--select * from Production.Product
select count(P.ProductID) as [N�mero de productos],PC.[Name] from Production.ProductCategory as PC
inner join Production.ProductSubcategory as PS on PC.ProductCategoryID=PS.ProductCategoryID
inner join Production.Product as P on PS.ProductSubcategoryID=P.ProductSubcategoryID
group by PC.[Name]

--6.Igual a la anterior, pero considerando las categor�as generales (categor�as de categor�as).
select count(P.ProductID) as [N�mero de productos],PC.[Name] from Production.Product as P
inner join Production.ProductSubcategory as PS on P.ProductSubcategoryID=PS.ProductSubcategoryID/*Duda*/
inner join Production.ProductCategory as PC on PS.ProductCategoryID=PC.ProductCategoryID
group by PC.[Name]

--7.N�mero de unidades vendidas de cada producto cada a�o.
select count(SOH.SalesOrderID) as [N�mero de unidades vendidas de cada producto cada a�o],SOD.ProductID,year(SOH.OrderDate) as [A�o] from Sales.SalesOrderHeader as SOH
inner join Sales.SalesOrderDetail as SOD on SOH.SalesOrderID=SOD.SalesOrderID
group by SOD.ProductID,year(SOH.OrderDate)
order by SOD.ProductID

--8.Nombre completo, compa��a y total facturado a cada cliente
--select * from Sales.SalesOrderHeader
select P.FirstName,P.MiddleName,P.LastName from Person.Person as P
inner join Sales.Customer as C on P.BusinessEntityID=C.PersonID/**************************/
inner join Sales.SalesOrderHeader as SOH on C.PersonID=SOH.CustomerID
inner join Sales.SalesOrderDetail as SOD on SOH.SalesOrderID=SOD.SalesOrderID
 
--9.N�mero de producto, nombre y precio de todos aquellos en cuya descripci�n aparezcan 
--las palabras "race�, "competition� o "performance�
--select * from Sales.SpecialOffer
--select * from Production.Product
select P.ProductNumber,P.Name,P.StandardCost,P.ListPrice from Production.Product as P
inner join Sales.SpecialOfferProduct as SOP on P.ProductID=SOP.ProductID
inner join Sales.SpecialOffer as SO on SOP.SpecialOfferID=SO.SpecialOfferID
where SO.[Description] in ('race','competition','performance')
go

--Consultas avanzadas

--10.Facturaci�n total en cada pa�s
select TerritoryID,TotalDue from Sales.SalesOrderHeader

--11.Facturaci�n total en cada Estado

--12.Margen medio de beneficios y total facturado en cada pa�s
