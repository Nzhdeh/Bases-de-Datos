--Lenguaje SQL. Consultas
--Escribe el c�digo SQL necesario para realizar las siguientes operaciones sobre la base de datos
--�NorthWind�
--De la 1 a la 7 se pueden hacer sin usar funciones de agregados.
--Consultas sobre una sola Tabla

use Northwind
go

--1. Nombre de la compa��a y direcci�n completa (direcci�n, cuidad, pa�s) de todos los
--clientes que no sean de los Estados Unidos.
select CompanyName,[Address],City,Country from Customers
where Country <> 'USA'
go

--2. La consulta anterior ordenada por pa�s y ciudad.
select CompanyName,[Address],City,Country from Customers
where Country <> 'USA'
order by Country, City
go

--3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antig�edad en la empresa.
select LastName,FirstName,City,(year(CURRENT_TIMESTAMP)-year(BirthDate)) as Edad from Employees
order by HireDate asc
go
--select LastName,FirstName,HireDate from Employees		--para comprobar
--order by HireDate asc

--4. Nombre y precio de cada producto, ordenado de mayor a menor precio.
select ProductName,UnitPrice from Products
order by UnitPrice desc
go
--5. Nombre de la compa��a y direcci�n completa de cada proveedor de alg�n pa�s de Am�rica del Norte.
select CompanyName,[Address],City,Country from Suppliers/************************/

--6. Nombre del producto, n�mero de unidades en stock y valor total del stock, de los
--productos que no sean de la categor�a 4.


--7. Clientes (Nombre de la Compa��a, direcci�n completa, persona de contacto) que no
--residan en un pa�s de Am�rica del Norte y que la persona de contacto no sea el
--propietario de la compa��a


--8. ID del cliente y n�mero de pedidos realizados por cada cliente, ordenado de mayor a
--menor n�mero de pedidos.


--9. N�mero de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad.


--10. N�mero de productos de cada categor�a. 