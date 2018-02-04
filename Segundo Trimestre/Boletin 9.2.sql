--Escribe las siguientes consultas sobre la base de datos NorthWind.
--Pon el enunciado como comentario junta a cada una

use Northwind
go

--PROBLEMA
--1. N�mero de clientes de cada pa�s.
select count(*) as [Numero de clientes en cada pais],Country from Customers
group by Country
go
--2. N�mero de clientes diferentes que compran cada producto.
select OD.ProductID,count(distinct C.CustomerID) as [Numero de clientes diferentes] from Customers as C
inner join Orders as O on C.CustomerID=O.CustomerID
inner join [Order Details] as OD on O.OrderID=OD.OrderID
group by OD.ProductID
go
--3. N�mero de pa�ses diferentes en los que se vende cada producto.
select P.ProductName,count(distinct O.ShipCountry) as [N�mero de pa�ses diferentes] from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID
group by P.ProductName
go
--4. Empleados que han vendido alguna vez �Gudbrandsdalsost�, �Lakkalik��ri�,
--�Tourti�re� o �Boston Crab Meat�.
select distinct E.EmployeeID,E.FirstName,E.LastName from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID
where P.ProductName in ('Gudbrandsdalsost','Lakkalik��ri','Tourti�re','Boston Crab Meat')
go
--5. Empleados que no han vendido nunca �Chartreuse verte� ni �Ravioli Angelo�.
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
--6. N�mero de unidades de cada categor�a de producto que ha vendido cada empleado.
select E.LastName,E.FirstName,C.CategoryName,count(*) as [N�mero de unidades de cada categor�a] from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join [Order Details] as OD on O.OrderID=OD.OrderID 
inner join Products as P on OD.ProductID=P.ProductID
inner join Categories as C on P.CategoryID=C.CategoryID
group by C.CategoryName,E.LastName,E.FirstName
order by E.LastName,E.FirstName
go
--7. Total de ventas (US$) de cada categor�a en el a�o 97.
select C.CategoryName,sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as [Total de ventas de cada categor�a] from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID 
inner join Products as P on OD.ProductID=P.ProductID
inner join Categories as C on P.CategoryID=C.CategoryID
group by C.CategoryName,year(O.OrderDate)
having year(O.OrderDate)=1997
go
--8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
--nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
--lo han comprado.
select P.ProductID,C.Country,count (distinct C.CustomerID) as [Clientes] from Products as P
inner join [Order Details] as OD on P.ProductID=OD.ProductID
inner join Orders as O on OD.OrderID=O.OrderID
inner join Customers as C on O.CustomerID=C.CustomerID
group by P.ProductID,C.Country
having count(distinct C.CustomerID)>1
go
--9. Total de ventas (US$) en cada pa�s cada a�o.
select sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as [Total de ventas],O.ShipCountry,year(O.OrderDate) as [A�o] from [Order Details] as OD
inner join Orders as O on OD.OrderID=O.OrderID
group by O.ShipCountry,year(O.OrderDate)
order by year(O.OrderDate)

--10. Producto superventas de cada a�o, indicando a�o, nombre del producto,
--categor�a y cifra total de ventas.
select year(O.OrderDate) as A�o,P.ProductName,C.CategoryName,sum(OD.Quantity) as [Unidades Vendidas Top Ventas] from Categories AS C
INNER JOIN Products as P on C.CategoryID=P.CategoryID
INNER JOIN [Order Details] as OD on P.ProductID=OD.ProductID
INNER JOIN Orders as O on OD.OrderID=O.OrderID
INNER JOIN(
select [Unidades Vendidas por a�o y producto].A�o,max([Unidades Vendidas por a�o y producto].[Unidades Vendidas]) as [M�s vendido] from Products as P
INNER JOIN [Order Details] as OD on P.ProductID=OD.ProductID
INNER JOIN Orders as O on OD.OrderID=O.OrderID
INNER JOIN(
	select P.ProductID,P.ProductName,C.CategoryID, year(O.OrderDate) as A�o,sum(OD.Quantity) as [Unidades Vendidas] from Products as P
	INNER JOIN Categories as C on P.CategoryID=C.CategoryID
	INNER JOIN [Order Details] as OD on P.ProductID=OD.ProductID
	INNER JOIN Orders as O on OD.OrderID=O.OrderID
	group by P.ProductID,P.ProductName,C.CategoryID, year(O.OrderDate)
	) as [Unidades Vendidas por a�o y producto] on [Unidades Vendidas por a�o y producto].ProductID=P.ProductID
group by [Unidades Vendidas por a�o y producto].A�o
) as UDSDELTOPVENTAS on UDSDELTOPVENTAS.A�o=year(O.OrderDate)
group by P.ProductName,C.CategoryName,year(O.OrderDate),UDSDELTOPVENTAS.[M�s vendido]
having sum(OD.Quantity)=UDSDELTOPVENTAS.[M�s vendido]
Order by A�o

--11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
--respecto al a�o anterior en US $ y en %.
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


--12. Mejor cliente (el que m�s nos compra) de cada pa�s.


--13. N�mero de productos diferentes que nos compra cada cliente.
select O.CustomerID,count(distinct OD.ProductID) as [Numero de productos diferentes] from [Order Details] as OD
inner join Orders as O on OD.OrderID=O.OrderID
group by O.CustomerID

--14. Clientes que nos compran m�s de cinco productos diferentes.
select distinct O.CustomerID from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID
group by O.CustomerID
having count (distinct OD.ProductID)>5

--15. Vendedores que han vendido una mayor cantidad que la media en US $ en el a�o 97.


--16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos
--a�os consecutivos, indicando el a�o en que se produjo el aumento.