--Escribe las siguientes consultas sobre la base de datos NorthWind.
use Northwind
go

--1. Nombre de los proveedores y número de productos que nos vende cada uno
select S.CompanyName,count(P.ProductID) as [Número de productos vendidos por los proveedores] from Suppliers as S
inner join Products as P on S.SupplierID=P.SupplierID
group by S.CompanyName
go

--2. Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
--select * from Suppliers
select LastName,FirstName ,HomePhone,City from Employees
where City in ('New York','Seattle','Vermont','Columbia','Los Angeles','Redmond','Atlanta')
go
--3. Número de productos de cada categoría y nombre de la categoría.
select count(P.ProductID) as [Número de productos de cada categoría],C.CategoryName from Products as P
inner join Categories as C on P.CategoryID=P.CategoryID
group by C.CategoryName
go
--4. Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.
select C.CompanyName/*,P.ProductName*/ from Customers as C
inner join Orders as O on C.CustomerID=O.CustomerID
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID
where P.ProductName in('queso de cabrales','tofu')
go
--5. Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.
--select * from Employees
--select ShipName from Orders

Select E.EmployeeID, E.LastName, E.FirstName, E.HomePhone from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join Customers as C on O.CustomerID=C.CustomerID
where CompanyName in('Bon app''','Meter Franken')
go

--6. Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *
--select * from Employees

select distinct E.EmployeeID, E.LastName, E.FirstName,datepart(Month,E.BirthDate) as Mes,datepart(day,E.BirthDate) as Dia from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join Customers as C on O.CustomerID=C.CustomerID/***************************/
where C.Country!='France'
order by e.EmployeeID
go

--7. Total de ventas en US$ de productos de cada categoría (nombre de la categoría).
Select C.CategoryName,sum((OD.UnitPrice-(OD.UnitPrice*OD.Discount))*OD.Quantity) as [Total de ventas] from Products as P
inner join [Order Details] as OD on P.ProductID=OD.ProductID
inner join Categories as C on P.CategoryID=C.CategoryID
group by C.CategoryName

--8. Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).
select sum((OD.UnitPrice-(OD.UnitPrice*OD.Discount))*OD.Quantity) as [Total de ventas de cada empleado],E.LastName, E.FirstName,E.[Address] from Employees as E
inner join Orders as O on E.EmployeeID=O.EmployeeID
inner join [Order Details] as OD on O.OrderID=OD.OrderID
group by E.LastName,E.FirstName,E.[Address]

--9. Ventas de cada producto en el año 97. Nombre del producto y unidades.
select sum((OD.UnitPrice-(OD.UnitPrice*OD.Discount))*OD.Quantity) as [Ventas de cada producto],P.ProductName,P.UnitsOnOrder from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID/**********************************************/
Where ShippedDate=year(1997)
group by P.ProductName,P.UnitsOnOrder
go
--10. Cuál es el producto del que hemos vendido más unidades en cada país. *
select P.ProductName,C.Country,sum(OD.Quantity) as [Cantidad de unidades vendidas] from Products as P
inner join [Order Details] as OD on P.ProductID=OD.ProductID
inner join Orders as O on OD.OrderID=O.OrderID
inner join Customers as C on O.CustomerID=C.CustomerID--hay que hacerlo con subconsultas
group by P.ProductName,C.Country
order by [Cantidad de unidades vendidas] desc
go
--11. Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.
select E.FirstName,E.LastName from Employees as E
inner join Employees as Boss on E.ReportsTo=Boss.EmployeeID
where Boss.FirstName='Andrew' and Boss.LastName='Fuller'

--12. Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
select Esclavo.EmployeeID,Esclavo.FirstName,Esclavo.LastName,count(*) as [Numero de subordinados] from Employees as E
inner join Employees as Esclavo on E.ReportsTo=Esclavo.EmployeeID
group by Esclavo.EmployeeID,Esclavo.FirstName,Esclavo.LastName