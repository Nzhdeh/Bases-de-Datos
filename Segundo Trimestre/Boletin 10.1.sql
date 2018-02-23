use AdventureWorks2012
go

--1. Nombre y direcci�n completas de todos los clientes que tengan alguna sede en Canada.
select * from Person.Person as P
inner join Sales.Customer as C on P.BusinessEntityID=C.PersonID
inner join Sales.SalesOrderHeader as SOH on c.CustomerID=SOH.CustomerID


--2. Nombre de cada categor�a y producto m�s caro y m�s barato de la misma, incluyendo los precios.

--select P.[Name],PK.[Name],max(P.ListPrice) as [Precio maximo],min(P.ListPrice) as [Precio minimo] from Production.ProductCategory as PK
--inner join Production.ProductSubcategory as PSC on PK.ProductCategoryID=PSC.ProductCategoryID
--inner join Production.Product as P on PSC.ProductSubcategoryID=P.ProductSubcategoryID
--group by  P.[Name],PK.[Name] 
go
alter view ProductosPorPrecioYNombre as
select P.ProductID,P.[Name] as NombreProducto,PK.[Name] as CategoryName,P.ListPrice from Production.ProductCategory as PK
inner join Production.ProductSubcategory as PSC on PK.ProductCategoryID=PSC.ProductCategoryID
inner join Production.Product as P on PSC.ProductSubcategoryID=P.ProductSubcategoryID
group by  P.ProductID,P.[Name],PK.[Name],P.ListPrice 
go

create view ProductoMasCaroYMasBarato as
select PPPN.CategoryName,max(PPPN.ListPrice) as PrecioMaximo,min(PPPN.ListPrice) as PrecioMinimo  
from ProductosPorPrecioYNombre as PPPN
group by PPPN.CategoryName
go



select  PPPYN.ProductID, PPPYN.CategoryName,PMC.PrecioMaximo,PMB.PrecioMinimo 
	from ProductoMasCaroYMasBarato as PMC 
	inner join ProductosPorPrecioYNombre as PPPYNC
		 on PPPYN.CategoryName=PMC.CategoryName and PPPYN.ListPrice=PMC.PrecioMaximo
	inner join ProductosPorPrecioYNombre as PPPYNB
		 on PPPYN.CategoryName=PMC.CategoryName and PPPYN.ListPrice=PMC.PrecioMinimo
		
go

--3. Total de Ventas en cada pa�s en dinero (Ya hecha en el bolet�n 9.3).

--4. N�mero de clientes que tenemos en cada pa�s. Contaremos cada direcci�n como si fuera un cliente distinto.

--5. Repite la consulta anterior pero contando cada cliente una sola vez. Si el cliente tiene varias 

--direcciones, s�lo consideraremos aquella en la que nos haya comprado la �ltima vez.

--6. Repite la consulta anterior pero en este caso si el cliente tiene varias direcciones, s�lo 
--consideraremos aquella en la que nos haya comprado m�s.

--7. Los tres pa�ses en los que m�s hemos vendido, incluyendo la cifra total de ventas y la fecha de la �ltima venta.

--8. Sobre la consulta tres de ventas por pa�s, calcula el valor medio y repite la consulta tres 
--pero incluyendo solamente los pa�ses cuyas ventas est�n por encima de la media.

--9. Nombre de la categor�a y n�mero de clientes diferentes que han comprado productos de cada una.

--10. Clientes que nunca han comprado ninguna bicicleta (discriminarlas por categor�as)

--11. A la consulta anterior, a��dele el total de compras (en dinero) efectuadas por cada cliente.