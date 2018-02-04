--Escribe las siguientes consultas sobre la base de datos NorthWind.
--Pon el enunciado como comentario junta a cada una

use Northwind
go

--PROBLEMA
--1. Número de clientes de cada país.
select count(*) as [Numero de clientes en cada pais],Country from Customers
group by Country
go
--2. Número de clientes diferentes que compran cada producto.
select OD.ProductID,count(distinct C.CustomerID) as [Numero de clientes diferentes] from Customers as C
inner join Orders as O on C.CustomerID=O.CustomerID
inner join [Order Details] as OD on O.OrderID=OD.OrderID
group by OD.ProductID
go
--3. Número de países diferentes en los que se vende cada producto.
select P.ProductName,count(distinct O.ShipCountry) as [Número de países diferentes] from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID
group by P.ProductName
go
--4. Empleados que han vendido alguna vez “Gudbrandsdalsost”, “Lakkalikööri”,
--“Tourtière” o “Boston Crab Meat”.
select distinct E.EmployeeID,E.FirstName,E.LastName from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID
where P.ProductName in ('Gudbrandsdalsost','Lakkalikööri','Tourtière','Boston Crab Meat')
go
--5. Empleados que no han vendido nunca “Chartreuse verte” ni “Ravioli Angelo”.
select distinct E.EmployeeID,E.FirstName,E.LastName from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join [Order Details] as OD on O.OrderID=OD.OrderID			--preguntar a Leo
inner join Products as P on OD.ProductID=P.ProductID
where P.ProductName not in ('Chartreuse verte','Ravioli Angelo')
go

select distinct E.EmployeeID,E.FirstName,E.LastName from Employees as E
except
select distinct E.EmployeeID,E.FirstName,E.LastName from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID
where P.ProductName in ('Chartreuse verte','Ravioli Angelo')
go
--6. Número de unidades de cada categoría de producto que ha vendido cada empleado.
select E.LastName,E.FirstName,C.CategoryName,count(*) as [Número de unidades de cada categoría] from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join [Order Details] as OD on O.OrderID=OD.OrderID 
inner join Products as P on OD.ProductID=P.ProductID
inner join Categories as C on P.CategoryID=C.CategoryID
group by C.CategoryName,E.LastName,E.FirstName
order by E.LastName,E.FirstName
go
--7. Total de ventas (US$) de cada categoría en el año 97.
select C.CategoryName,sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as [Total de ventas de cada categoría] from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID 
inner join Products as P on OD.ProductID=P.ProductID
inner join Categories as C on P.CategoryID=C.CategoryID
group by C.CategoryName,year(O.OrderDate)
having year(O.OrderDate)=1997
go
--8. Productos que han comprado más de un cliente del mismo país, indicando el
--nombre del producto, el país y el número de clientes distintos de ese país que
--lo han comprado.
select P.ProductID,C.Country,count (distinct C.CustomerID) as [Clientes] from Products as P
inner join [Order Details] as OD on P.ProductID=OD.ProductID
inner join Orders as O on OD.OrderID=O.OrderID
inner join Customers as C on O.CustomerID=C.CustomerID
group by P.ProductID,C.Country
having count(distinct C.CustomerID)>1
go
--9. Total de ventas (US$) en cada país cada año.
select sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as [Total de ventas],O.ShipCountry,year(O.OrderDate) as [Año] from [Order Details] as OD
inner join Orders as O on OD.OrderID=O.OrderID
group by O.ShipCountry,year(O.OrderDate)
order by year(O.OrderDate)

--10. Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas.
select year(O.OrderDate) as Año,P.ProductName,C.CategoryName,sum(OD.Quantity) as [Unidades Vendidas Top Ventas] from Categories AS C
INNER JOIN Products as P on C.CategoryID=P.CategoryID
INNER JOIN [Order Details] as OD on P.ProductID=OD.ProductID
INNER JOIN Orders as O on OD.OrderID=O.OrderID
INNER JOIN(
select [Unidades Vendidas por año y producto].Año,max([Unidades Vendidas por año y producto].[Unidades Vendidas]) as [Más vendido] from Products as P
INNER JOIN [Order Details] as OD on P.ProductID=OD.ProductID
INNER JOIN Orders as O on OD.OrderID=O.OrderID
INNER JOIN(
	select P.ProductID,P.ProductName,C.CategoryID, year(O.OrderDate) as Año,sum(OD.Quantity) as [Unidades Vendidas] from Products as P
	INNER JOIN Categories as C on P.CategoryID=C.CategoryID
	INNER JOIN [Order Details] as OD on P.ProductID=OD.ProductID
	INNER JOIN Orders as O on OD.OrderID=O.OrderID
	group by P.ProductID,P.ProductName,C.CategoryID, year(O.OrderDate)
	) as [Unidades Vendidas por año y producto] on [Unidades Vendidas por año y producto].ProductID=P.ProductID
group by [Unidades Vendidas por año y producto].Año
) as UDSDELTOPVENTAS on UDSDELTOPVENTAS.Año=year(O.OrderDate)
group by P.ProductName,C.CategoryName,year(O.OrderDate),UDSDELTOPVENTAS.[Más vendido]
having sum(OD.Quantity)=UDSDELTOPVENTAS.[Más vendido]
Order by Año

--11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución
--respecto al año anterior en US $ y en %.
select P.ProductID,P.ProductName, sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as [Cifra de ventas de cada producto],(SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount)))-[Cifra de ventas del 96]) AS [Aumento/Disminucion],(((SUM(OD.Quantity*(OD.UnitPrice*(1-OD.Discount)))/[Cifra de ventas del 96])-1)*100) AS [Porcentaje crecimiento de ventas] from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID
inner join (
			select P.ProductID,P.ProductName, sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as [Cifra de ventas del 96] from Orders as O
			inner join [Order Details] as OD on O.OrderID=OD.OrderID
			inner join Products as P on OD.ProductID=P.ProductID
			where year(O.OrderDate)=1996
			group by P.ProductName,P.ProductID
)AS [Ventas 1996] ON P.ProductID=[Ventas 1996].ProductID
where year(O.OrderDate)=1997
group by P.ProductName,P.ProductID,[Cifra de ventas del 96]
order by P.ProductID


--12. Mejor cliente (el que más nos compra) de cada país.


--13. Número de productos diferentes que nos compra cada cliente.
select O.CustomerID,count(distinct OD.ProductID) as [Numero de productos diferentes] from [Order Details] as OD
inner join Orders as O on OD.OrderID=O.OrderID
group by O.CustomerID

--14. Clientes que nos compran más de cinco productos diferentes.
select distinct O.CustomerID from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID
group by O.CustomerID
having count (distinct OD.ProductID)>5

--15. Vendedores que han vendido una mayor cantidad que la media en US $ en el año 97.


--16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos
--años consecutivos, indicando el año en que se produjo el aumento.