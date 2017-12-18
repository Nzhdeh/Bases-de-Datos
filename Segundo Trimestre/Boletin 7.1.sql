--Lenguaje SQL. Consultas
--Escribe el código SQL necesario para realizar las siguientes operaciones sobre la base de datos
--“NorthWind”
--De la 1 a la 7 se pueden hacer sin usar funciones de agregados.
--Consultas sobre una sola Tabla

use Northwind
go

--1. Nombre de la compañía y dirección completa (dirección, cuidad, país) de todos los
--clientes que no sean de los Estados Unidos.
select CompanyName,[Address],City,Country from Customers
where Country <> 'USA'
go

--2. La consulta anterior ordenada por país y ciudad.
select CompanyName,[Address],City,Country from Customers
where Country <> 'USA'
order by Country, City
go

--3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antigüedad en la empresa.
select LastName,FirstName,City,(year(CURRENT_TIMESTAMP)-year(BirthDate)) as Edad from Employees
order by HireDate asc
go
--select LastName,FirstName,HireDate from Employees		--para comprobar
--order by HireDate asc

--4. Nombre y precio de cada producto, ordenado de mayor a menor precio.
select ProductName,UnitPrice from Products
order by UnitPrice desc
go
--5. Nombre de la compañía y dirección completa de cada proveedor de algún país de América del Norte.
select CompanyName,[Address],City,Country from Suppliers
where Country in( 'USA','Mexico','Canada')
go
--6. Nombre del producto, número de unidades en stock y valor total del stock, de los
--productos que no sean de la categoría 4.
select ProductName,UnitsInStock,UnitPrice from Products
where CategoryID<>4
go

--7. Clientes (Nombre de la Compañía, dirección completa, persona de contacto) que no
--residan en un país de América del Norte y que la persona de contacto no sea el
--propietario de la compañía
select CompanyName,[Address],City,PostalCode,Country,ContactName from Customers
where Country not in( 'USA','Mexico','Canada') and ContactTitle!='Cowner'
go

--8. ID del cliente y número de pedidos realizados por cada cliente, ordenado de mayor a
--menor número de pedidos.
select CustomerID,count(OrderID) as [Pedidos Realizados] from Orders
group by CustomerID
order by [Pedidos Realizados] desc
go

--9. Número de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad.
select ShipCity,count(OrderID) as [NumeroPedidosPorCiudad] from Orders
group by ShipCity
go

--10. Número de productos de cada categoría. 
select CategoryID,count(CategoryID) as [Número de productos de cada categorí] from Products
group by CategoryID
go