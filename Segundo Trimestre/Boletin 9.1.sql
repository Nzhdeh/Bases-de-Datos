--Escribe las siguientes consultas sobre la base de datos NorthWind.
use Northwind
go

--Nombre de los proveedores y n�mero de productos que nos vende cada uno
select S.CompanyName,count(P.ProductID) as [N�mero de productos vendidos por los proveedores] from Suppliers as S
inner join Products as P on S.SupplierID=P.SupplierID
group by S.CompanyName
go

--Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
--select * from Suppliers
select LastName,FirstName ,HomePhone,City from Employees
where City in ('New York','Seattle','Vermont','Columbia','Los Angeles','Redmond','Atlanta')
go
--N�mero de productos de cada categor�a y nombre de la categor�a.
select count(P.ProductID) as [N�mero de productos de cada categor�a],C.CategoryName from Products as P
inner join Categories as C on P.CategoryID=P.CategoryID
group by C.CategoryName
go
--Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.
select C.CompanyName/*,P.ProductName*/ from Customers as C
inner join Orders as O on C.CustomerID=O.CustomerID
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID
where P.ProductName in('queso de cabrales','tofu')
go
--Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.
--select * from Employees
--select ShipName from Orders

Select E.EmployeeID, E.LastName, E.FirstName, E.HomePhone from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join Customers as C on O.CustomerID=C.CustomerID
where CompanyName in('Bon app''','Meter Franken')
go

--Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca nada a ning�n cliente de Francia. *
--select * from Employees

select E.EmployeeID, E.LastName, E.FirstName,datepart(Month,E.BirthDate) as Mes,datepart(day,E.BirthDate) as Dia from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join Customers as C on O.CustomerID=C.CustomerID
where C.Country!='France'
go

--Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).
Select C.CategoryName,sum((OD.UnitPrice-(OD.UnitPrice*OD.Discount))*OD.Quantity) as [Total de ventas] from Products as P
inner join [Order Details] as OD on P.ProductID=OD.ProductID
inner join Categories as C on P.CategoryID=C.CategoryID
group by C.CategoryName

--Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).
select sum((OD.UnitPrice-(OD.UnitPrice*OD.Discount))*OD.Quantity) as [Total de ventas de cada empleado],E.LastName, E.FirstName,E.[Address] from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join [Order Details] as OD on O.OrderID=OD.OrderID
group by E.LastName,E.FirstName,E.[Address]

--Ventas de cada producto en el a�o 97. Nombre del producto y unidades.


--Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. *


--Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.


--N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.